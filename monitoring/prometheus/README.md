# Monitoring and Alerting Stack

This lab provides a containerized monitoring, visualization, and alert-management stack using Docker Compose.

## Components

- Prometheus collects and stores time-series metrics.
- Node Exporter exposes Linux host metrics.
- Alertmanager receives, groups, silences, and routes alerts.
- Grafana queries Prometheus and visualizes the collected metrics.
- The webhook receiver accepts and logs firing and resolved Alertmanager notifications.

## Architecture

```text
Linux host
    |
    v
Node Exporter
    |
    v
Prometheus --------> Alertmanager --------> Webhook Receiver
    |
    v
Grafana
```

## Monitored Targets

Prometheus collects metrics from:

- Prometheus itself
- Node Exporter
- Alertmanager

The `up` metric reports whether each target is reachable.

## Alert Rule

The `TargetDown` rule fires when a monitored target remains unavailable for more than 30 seconds.

```text
inactive -> pending -> firing -> resolved
```

Alertmanager silences can suppress notifications during planned maintenance without disabling metric collection or alert evaluation.

## Webhook Notifications

Alertmanager sends both firing and resolved notifications to the private webhook receiver at `http://webhook-receiver:8080/alerts`.

The receiver:

- Accepts Alertmanager JSON payloads
- Logs alert labels, annotations, status, and timestamps
- Returns HTTP `200` after accepting a notification
- Provides a `/health` endpoint for its container health check
- Runs as a non-root user
- Is reachable only inside the Docker Compose network

Notification flow:

```text
Target fails
    -> Prometheus fires TargetDown
    -> Alertmanager routes the alert
    -> Webhook receiver logs a firing notification
    -> Target recovers
    -> Webhook receiver logs a resolved notification
```

## Persistent Alert History

The webhook receiver stores every firing and resolved notification as one JSON object per line in `/data/alerts.jsonl`.

The `webhook-history` Docker named volume preserves this file when the receiver container is recreated. The private `GET /alerts` endpoint returns the 50 most recent stored notifications.

Inspect recent history from inside the container:

```bash
docker compose exec webhook-receiver \
  python -c 'import urllib.request; print(urllib.request.urlopen("http://127.0.0.1:8080/alerts").read().decode())'
```

## Grafana Dashboard

The provisioned `DevOps Lab Overview` dashboard displays:

- Linux one-minute load average
- CPU usage
- Memory usage
- Root filesystem usage
- Prometheus target availability

The Prometheus data source and dashboard are provisioned automatically from files under `grafana/`.

## Start the Stack

```bash
docker compose up --detach
docker compose ps
```
## Published Webhook Image

Release builds of the webhook receiver are published to GitHub Container Registry for AMD64 and ARM64 systems.

Docker Compose defaults to the explicit `v0.1.1` image rather than relying on the mutable `latest` tag. The `WEBHOOK_IMAGE` variable allows an operator to override that default for controlled rollback.

```bash
docker pull ghcr.io/pzhendov/webhook-receiver:v0.1.1
```

The `latest` tag points to the most recently published release:

```bash
docker pull ghcr.io/pzhendov/webhook-receiver:latest
```

Deploy the default pinned version:

```bash
docker compose pull webhook-receiver

docker compose up \
  --detach \
  --no-deps \
  --force-recreate \
  webhook-receiver
```

Starting with `v0.1.1`, release images report their embedded version:

```bash
docker compose exec webhook-receiver \
  python -c 'import urllib.request; print(urllib.request.urlopen("http://127.0.0.1:8080/version").read().decode())'
```

Temporarily roll back to `v0.1.0`:

```bash
WEBHOOK_IMAGE=ghcr.io/pzhendov/webhook-receiver:v0.1.0 \
  docker compose pull webhook-receiver

WEBHOOK_IMAGE=ghcr.io/pzhendov/webhook-receiver:v0.1.0 \
  docker compose up \
    --detach \
    --no-deps \
    --force-recreate \
    webhook-receiver
```

## Health Checks

Prometheus:

```bash
curl --fail http://127.0.0.1:9090/-/ready
```

Alertmanager:

```bash
curl --fail http://127.0.0.1:9093/-/ready
```

Grafana:

```bash
curl --fail http://127.0.0.1:3000/api/health
```

Webhook receiver:

```bash
docker compose exec webhook-receiver \
python -c 'import urllib.request; print(urllib.request.urlopen("http://127.0.0.1:8080/health").read().decode())'
```

## Access from a Remote Computer

The management interfaces bind only to the VM loopback address. Use SSH forwarding from the local computer:

```bash
ssh -N \
  -L 3000:127.0.0.1:3000 \
  -L 9090:127.0.0.1:9090 \
  -L 9093:127.0.0.1:9093 \
  devops-lab
```

Open:

- Grafana: `http://127.0.0.1:3000`
- Prometheus: `http://127.0.0.1:9090`
- Alertmanager: `http://127.0.0.1:9093`

## Persistent Data

Docker named volumes store runtime data:

- `prometheus-data`
- `alertmanager-data`
- `grafana-data`
- `webhook-history`

Runtime metrics, passwords, silences, alert notification history, and database files are not committed to Git. Grafana’s Prometheus data source and dashboard are stored as provisioning configuration so they can be recreated from the repository.

## Validation

The GitHub Actions workflow validates:

- Docker Compose configuration
- Prometheus configuration
- Prometheus alert rules
- Alertmanager configuration
- Grafana provisioning YAML
- Grafana dashboard JSON
- Webhook receiver Python syntax
- Webhook receiver image build
- Webhook receiver health endpoint
- Webhook receiver history persistence across container recreation