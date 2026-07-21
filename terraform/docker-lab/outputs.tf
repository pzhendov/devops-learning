output "container_name" {
  description = "Terraform-managed Docker container"
  value       = docker_container.nginx.name
}

output "application_url" {
  description = "URL exposed by the Ubuntu VM"
  value       = "http://192.168.252.2:${var.external_port}"
}

output "network_name" {
  description = "Terraform-managed Docker network"
  value       = docker_network.lab.name
}

output "volume_name" {
  description = "Terraform-managed Docker volume"
  value       = docker_volume.nginx_cache.name
}

output "state_storage" {
  description = "Location where Terraform state is stored"
  value       = "HCP Terraform"
}
