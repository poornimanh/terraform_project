terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# AWS EC2 Instance to run Docker
resource "aws_instance" "docker_host" {
  ami           = "ami-0f5ee92e2d63afc18"  # Amazon Linux 2 for ap-south-1
  instance_type = "t2.micro"
  key_name      = "my-aws-key"  # Replace with your actual AWS Key Pair

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable docker
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              sudo docker pull flask_app_image
              sudo docker run -d -p 5000:5000 flask_app_image
              EOF

  tags = {
    Name = "DockerServer"
  }
}

# Docker Container (Runs locally for development)
resource "docker_container" "my_app" {
  image = "flask_image"
  name  = "flask_container"

  ports {
    internal = 5000
    external = 5000
  }

  depends_on = [aws_instance.docker_host]
}

output "instance_public_ip" {
  value = aws_instance.docker_host.public_ip
  description = "Public IP of the Docker Host EC2 instance"
}