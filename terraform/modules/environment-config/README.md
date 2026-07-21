# Environment Config Module

This Terraform module generates a configuration file for one application environment.

## Usage

```hcl
module "environment" {
  source = "../modules/environment-config"

  environment      = "development"
  team_name        = "DevOps Team"
  port             = 8080
  replicas         = 1
  output_directory = "${path.root}/generated"
}
```

## Inputs

| Name | Type | Description |
|---|---|---|
| `environment` | string | Environment name |
| `team_name` | string | Responsible team |
| `port` | number | Application port |
| `replicas` | number | Number of replicas |
| `output_directory` | string | Destination directory |

## Outputs

| Name | Description |
|---|---|
| `filename` | Path of the generated configuration file |
