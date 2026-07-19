terraform {
  required_version = "~> 1.15.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
  }
}

resource "local_file" "learning_notes" {
  filename        = "${path.module}/terraform-notes.txt"
  file_permission = "0644"

  content = <<-EOT
    Terraform learning report

    Learner: ${var.learner_name}
    Topic: ${var.lesson_topic}

    This resource is managed as Infrastructure as Code.
  EOT
}

output "created_file" {
  description = "Path of the file managed by Terraform"
  value       = local_file.learning_notes.filename
}