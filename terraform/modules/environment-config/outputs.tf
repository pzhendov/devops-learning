output "filename" {
  description = "Path of the generated environment configuration"
  value       = local_file.environment_config.filename
}