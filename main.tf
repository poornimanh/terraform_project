terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "os_type" {
  description = "Operating System Type"
  type        = string
  default     = "linux"  # Default to Linux for CI/CD environments
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}


resource "docker_container" "my_app" {
  image = "flask_app_image"
  name  = "my_flask_container"
  ports {
    internal = 5000
    external = 5000
  }
}