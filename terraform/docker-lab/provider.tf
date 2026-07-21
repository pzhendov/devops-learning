provider "docker" {
  host = var.docker_host

  ssh_opts = [
    "-o", "BatchMode=yes"
  ]
}