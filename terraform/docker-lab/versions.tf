terraform {
  required_version = "~> 1.15.0"

  cloud {
    organization = "pzhendov-devops-learning"

    workspaces {
      name = "docker-lab"
    }
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.5.0"
    }
  }
}
