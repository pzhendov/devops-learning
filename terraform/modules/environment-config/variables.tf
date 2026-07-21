variable "environment" {
  description = "Environment represented by this configuration"
  type        = string
}

variable "team_name" {
  description = "Team responsible for the environment"
  type        = string
}

variable "port" {
  description = "Application port"
  type        = number

  validation {
    condition     = var.port >= 1 && var.port <= 65535
    error_message = "The port must be between 1 and 65535."
  }
}

variable "replicas" {
  description = "Number of application replicas"
  type        = number

  validation {
    condition     = var.replicas >= 1
    error_message = "There must be at least one replica."
  }
}

variable "output_directory" {
  description = "Directory where the configuration file is created"
  type        = string
}