locals {
  environments = {
    development = {
      port     = 8080
      replicas = 1
    }

    staging = {
      port     = 8081
      replicas = 4
    }

    production = {
      port     = 80
      replicas = 3
    }
  }
}

resource "local_file" "environment_config" {
  for_each = local.environments

  filename             = "${path.module}/generated/${each.key}.conf"
  directory_permission = "0755"
  file_permission      = "0644"

  content = templatefile("${path.module}/templates/environment.tftpl", {
    environment = each.key
    team        = var.team_name
    port        = each.value.port
    replicas    = each.value.replicas
  })
}