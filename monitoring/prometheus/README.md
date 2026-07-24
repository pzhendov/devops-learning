# Monitoring and Alerting Stack

This lab provides a containerized monitoring, visualization, and alert-management stack using Docker Compose.

## Components

- Prometheus collects and stores time-series metrics.
- Node Exporter exposes Linux host metrics.
- Alertmanager receives, groups, silences, and routes alerts.
- Grafana queries Prometheus and visualizes the collected metrics.

## Architecture

```text
Linux host
    |
    v
Node Exporter
    |
    v
Prometheus --------> Alertmanager
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

Runtime metrics, passwords, silences, and database files are not committed to Git. Grafana’s Prometheus data source and dashboard are stored as provisioning configuration so they can be recreated from the repository.

## Validation

The GitHub Actions workflow validates:

- Docker Compose configuration
- Prometheus configuration
- Prometheus alert rules
- Alertmanager configuration
- Grafana provisioning YAML
- Grafana dashboard JSON
