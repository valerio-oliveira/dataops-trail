terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

resource "aws_security_group" "application_group" {
  name        = "application_group"
  description = "Security group for application"
  vpc_id      = var.current_vpc_id

  dynamic "ingress" {
    for_each = var.application_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "application_group" }

}

resource "aws_security_group" "database_group" {
  name        = "database_group"
  description = "Security group for databases"
  vpc_id      = var.current_vpc_id

  dynamic "ingress" {
    for_each = var.database_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "database_group" }

}

resource "aws_security_group" "service_group" {
  name        = "service_group"
  description = "Security group for service hosts"
  vpc_id      = var.current_vpc_id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "service_group" }

}
