terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.provider_access_key
  secret_key = var.provider_secret_key
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.ssh_public_key)
}

resource "aws_security_group" "ec2_api_ports" {
  name = "ec2_api_ports"

  dynamic "ingress" {
    for_each = var.vm_connetion_ports_api
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

  tags = {
    Name = "ec2_api_ports"
  }
}

resource "aws_security_group" "ec2_db_ports" {
  name = "ec2_db_ports"

  dynamic "ingress" {
    for_each = var.vm_connetion_ports_db
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

  tags = {
    Name = "ec2_db_ports"
  }
}

module "apis" {
  count          = var.num_of_instances
  source         = "./modules/apis"
  username       = var.username
  counter        = count.index
  ssh_key_name   = aws_key_pair.ssh_key.key_name
  sec_group_name = aws_security_group.ec2_api_ports.name
  private_key    = file(var.ssh_private_key)
}

module "databases" {
  count          = var.num_of_instances
  source         = "./modules/databases"
  username       = var.username
  counter        = count.index
  ssh_key_name   = aws_key_pair.ssh_key.key_name
  sec_group_name = aws_security_group.ec2_db_ports.name
  private_key    = file(var.ssh_private_key)
}
