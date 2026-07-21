resource "local_file" "environment_config" {
  filename             = "${var.output_directory}/${var.environment}.conf"
  directory_permission = "0755"
  file_permission      = "0644"

  content = templatefile("${path.module}/templates/environment.tftpl", {
    environment = var.environment
    team        = var.team_name
    port        = var.port
    replicas    = var.replicas
  })
}