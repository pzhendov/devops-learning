# Prometheus Monitoring Stack

This lab provides a local monitoring and alerting stack using Docker Compose.

## Components

- Prometheus collects and stores time-series metrics.
- Node Exporter exposes Linux host metrics.
- Alertmanager receives, groups, silences, and routes alerts.

## Alert Rule

The `TargetDown` rule fires when a monitored Prometheus target remains unavailable for more than 30 seconds.

Alert lifecycle:

```text
inactive -> pending -> firing -> resolved
