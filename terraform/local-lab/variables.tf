variable "learner_name" {
  description = "Name included in the generated learning notes"
  type        = string
  default     = "Pavel"

  validation {
    condition     = length(trimspace(var.learner_name)) > 0
    error_message = "The learner name cannot be empty."
  }
}

variable "lesson_topic" {
  description = "Current Terraform learning topic"
  type        = string
  default     = "Terraform variables and planned changes"
}