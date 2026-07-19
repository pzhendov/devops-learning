# DevOps Learning

This repository contains my practical DevOps learning exercises and projects.

## Topics Practised

- Terminal navigation
- Linux files and directories
- Users, groups and file permissions
- Processes, services and system logs
- Linux networking and firewalls
- Bash scripting and exit codes
- Git commits, branches and pull requests
- GitHub SSH authentication
- GitHub Actions continuous integration
- Nginx web-server administration
- Docker images and containers
- Container ports, networks and health checks
- Bind mounts and named volumes
- Docker Compose
- Multi-container applications
- Terraform configuration and providers
- Terraform state, plans and drift detection
- Terraform variables, locals and templates
- Terraform `for_each` and multiple resources

## Practical Projects

### Bash Health Check

A reusable Bash script that checks an Nginx endpoint and returns operational exit codes:

- `0` — healthy
- `1` — warning
- `2` — critical connection failure

### Containerized Nginx Website

A custom Nginx Docker image with:

- Versioned image releases
- Container health checks
- Docker Compose configuration
- Automated CI build and testing

### Visitor Counter Application

A multi-container application containing:

- Python and Flask
- Gunicorn application server
- Redis data service
- Docker internal networking
- Persistent Redis volume
- Service health checks
- Failure and recovery testing

### Terraform Local Infrastructure

Terraform exercises covering:

- Local provider resources
- Saved execution plans
- State management
- Drift detection and repair
- Input variables and `.tfvars`
- Maps, locals and `for_each`
- Template-generated environment configurations
- Controlled resource creation and removal

## Continuous Integration

GitHub Actions automatically performs:

- ShellCheck validation
- Docker image builds
- Container health tests
- Multi-container integration tests
- Terraform formatting
- Terraform initialization and validation
- Terraform execution plans

## Repository Workflow

Changes follow this workflow:

```text
Feature branch
    → local validation
    → commit
    → push
    → pull request
    → automated CI checks
    → merge into main

    
