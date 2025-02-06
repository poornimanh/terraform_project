terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}


resource "docker_container" "my_app" {
  image = "flask_image"
  name  = "flask_container"
  ports {
    internal = 5000
    external = 5000
  }
}