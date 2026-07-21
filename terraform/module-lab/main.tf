locals {
  environments = {
    development = {
      port     = 8080
      replicas = 1
    }

    staging = {
      port     = 8081
      replicas = 2
    }

    production = {
      port     = 80
      replicas = 3
    }
  }
}

module "environment" {
  source   = "../modules/environment-config"
  for_each = local.environments

  environment      = each.key
  team_name        = var.team_name
  port             = each.value.port
  replicas         = each.value.replicas
  output_directory = "${path.root}/generated"
}