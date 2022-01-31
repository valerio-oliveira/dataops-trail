terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

resource "aws_instance" "instance" {
  ami             = var.ami
  key_name        = var.key_name
  instance_type   = "t2.micro"
  security_groups = [var.security_group]
  subnet_id       = var.current_subnet_id
  tags = {
    Name = "${var.vm_name}"
  }
}
