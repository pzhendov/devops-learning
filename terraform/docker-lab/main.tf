resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_network" "lab" {
  name   = "terraform-lab-network"
  driver = "bridge"
}

resource "docker_volume" "nginx_cache" {
  name = "terraform-nginx-cache"
}

resource "docker_container" "nginx" {
  name  = "terraform-nginx"
  image = docker_image.nginx.image_id

  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 80
    external = var.external_port
    ip       = "0.0.0.0"
  }

  volumes {
    volume_name    = docker_volume.nginx_cache.name
    container_path = "/var/cache/nginx"
  }
}
