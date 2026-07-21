variable "docker_host" {
  description = "Docker Engine accessed securely through SSH"
  type        = string
  default     = "ssh://ubuntu@devops-lab:22"
}

variable "external_port" {
  description = "Port exposed by the VM"
  type        = number
  default     = 8090

  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535
    error_message = "Use an unprivileged port between 1024 and 65535."
  }
}