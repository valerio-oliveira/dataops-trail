terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

variable "security_ports" {
  type    = list(number)
  default = [22]
}

variable "current_vpc_id" {
  type = string
}

resource "aws_security_group" "security_ports" {
  name = "ec2_security"
  vpc_id = var.current_vpc_id

  dynamic "ingress" {
    for_each = var.security_ports
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

  tags = { Name = "Revolut security group" }
  
}