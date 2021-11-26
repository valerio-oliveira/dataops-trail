terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

# variable "ssh_key_name" {
#   type = string
# }

variable "sec_group_name" {
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

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name = format("%s_%s", data.aws_region.current.name, "ssh_key")
  #  public_key = file(var.ssh_public_key)
  public_key = file("~/.ssh/aws.pub")
}

resource "aws_instance" "instance" {
  ami             = data.aws_ami.ubuntu.id
  key_name        = aws_key_pair.ssh_key.key_name
  instance_type   = "t2.micro"
  security_groups = [var.sec_group_name]
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
