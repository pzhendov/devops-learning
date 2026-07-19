variable "team_name" {
  description = "Team responsible for the generated configurations"
  type        = string
  default     = "DevOps Learning Team"

  validation {
    condition     = length(trimspace(var.team_name)) > 0
    error_message = "The team name cannot be empty."
  }
}