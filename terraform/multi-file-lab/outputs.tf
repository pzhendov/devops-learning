output "generated_files" {
  description = "Configuration files generated for each environment"

  value = {
    for environment, file in local_file.environment_config :
    environment => file.filename
  }
}