terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

variable "ssh_public_key" {
  type = string
}

variable "ami" {}

variable "security_group" {
  type = string
}

variable "current_vpc_id" {
  type = string
}

variable "current_subnet_id" {
  type = string
}

variable "vm_name" {
  type = string
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "aws"
  public_key = file(var.ssh_public_key)
}

resource "aws_instance" "instance" {
  ami             = var.ami
  key_name        = aws_key_pair.ssh_key.key_name
  instance_type   = "t2.micro"
  security_groups = [var.security_group]
  subnet_id       = var.current_subnet_id
  tags = {
    Name = "${var.vm_name}"
  }
}

output "vm_id" {
  value = aws_instance.instance.id
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "public_dns" {
  value = aws_instance.instance.public_dns
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "private_dns" {
  value = aws_instance.instance.private_dns
}
