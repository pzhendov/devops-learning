# DevOps Learning Lab

[![Validate DevOps project](https://github.com/pzhendov/devops-learning/actions/workflows/ci.yml/badge.svg)](https://github.com/pzhendov/devops-learning/actions/workflows/ci.yml)

A hands-on DevOps learning repository built around practical Linux administration, automation, containers, Infrastructure as Code, CI/CD, networking, and observability.

The projects are developed in isolated Git branches, validated locally and in GitHub Actions, reviewed through pull requests, and merged into `main`.

## Core Skills Practised

### Linux and Networking

- Linux users, groups, permissions, processes, services, and logs
- systemd services and timers
- Filesystems, memory, CPU, load, and resource troubleshooting
- DNS resolution, routing, TCP ports, HTTP, HTTPS, and TLS
- UFW firewall behaviour and Docker networking
- Packet inspection with `tcpdump`
- Secure remote access with SSH and SCP

### Automation

- Bash scripts with arguments, validation, and operational exit codes
- Nginx deployment automation
- HTTP and TLS certificate health checks
- Cron and systemd scheduling
- ShellCheck validation

### Containers

- Docker images, containers, networks, volumes, and bind mounts
- Container health checks and versioned images
- Docker Compose application management
- Multi-container service communication
- Persistent application data
- Failure, recovery, and rollback testing

### Infrastructure as Code

- Terraform providers, resources, variables, locals, and outputs
- Saved plans, state inspection, drift detection, and repair
- `for_each`, templates, and multi-environment configuration
- Reusable Terraform modules
- Docker infrastructure managed through Terraform
- HCP Terraform remote state and state locking

### Observability

- Linux metrics with Node Exporter
- Metric collection and PromQL with Prometheus
- Alert lifecycle testing: inactive, pending, firing, and resolved
- Alert routing and maintenance silences with Alertmanager
- Grafana dashboards for CPU, memory, disk, load, and availability
- Provisioned Grafana data sources and dashboards
- Monitoring configuration stored and validated as code

## Practical Projects

### Linux Web Server Operations

An Nginx web server managed with Linux operational tooling:

- Custom webpage deployment
- systemd service health checks and timers
- Access and service-log inspection
- Firewall configuration
- Bash deployment and monitoring scripts

### Containerized Nginx

A custom Nginx container project featuring:

- Versioned Docker images
- Container health checks
- Port publishing
- Bind mounts and named volumes
- Docker Compose lifecycle management
- CI image build and runtime testing

### Multi-Container Visitor Counter

A small application stack containing:

- Python and Flask
- Gunicorn application server
- Redis persistence
- Docker internal DNS and networking
- Service dependencies and health checks
- Failure and recovery testing

### Terraform Labs

Infrastructure as Code exercises covering:

- Local resource management
- Multi-environment file generation
- Reusable environment modules
- Docker networks, volumes, images, and containers
- Drift recovery
- Remote state migration to HCP Terraform
- State versioning and locking

### Monitoring and Alerting Stack

A reproducible observability stack containing:

```text
Node Exporter ──> Prometheus ──> Alertmanager
                       │
                       └───────> Grafana
```

Key capabilities:

- Linux host metrics
- Prometheus scrape targets and alert rules
- `TargetDown` alert delivery and recovery
- Alertmanager routing and maintenance silences
- Persistent monitoring data
- Provisioned Prometheus data source
- Provisioned five-panel Grafana dashboard
- Clean-volume rebuild testing

See [monitoring/prometheus](monitoring/prometheus) for configuration and usage.

## Continuous Integration

GitHub Actions validates the repository on pushes and pull requests.

Checks include:

- Bash syntax and ShellCheck
- Required project files
- Docker Compose configuration
- Docker image builds
- Nginx runtime tests
- Visitor-counter integration tests
- Terraform formatting, initialization, validation, and plans
- Prometheus configuration and alert rules
- Alertmanager configuration
- Grafana provisioning YAML
- Grafana dashboard JSON

## Repository Structure

```text
.
├── .github/workflows/       # GitHub Actions
├── docker/                  # Container projects
├── monitoring/prometheus/   # Prometheus, Alertmanager, and Grafana
├── scripts/                 # Bash automation and health checks
├── systemd/                 # Service and timer units
├── terraform/               # Terraform labs and reusable modules
└── web/                     # Nginx webpage
```

## Development Workflow

```text
Create focused branch
        ↓
Implement and test locally
        ↓
Validate configuration
        ↓
Commit and push
        ↓
Open pull request
        ↓
Run GitHub Actions
        ↓
Merge into main
        ↓
Delete merged branch
```

## Current Focus

The current learning stage focuses on observability, alert notification routing, and operational troubleshooting.