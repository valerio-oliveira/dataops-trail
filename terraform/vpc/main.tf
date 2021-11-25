terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

variable "cidr_block" { }

variable "availability_zone" {
  type = string
}

resource "aws_vpc" "x" {
  cidr_block = var.cidr_block
  tags = { Name = "Revolut VPC" }
}

resource "aws_subnet" "s" {
    vpc_id = aws_vpc.x.id
    cidr_block = var.cidr_block
    map_public_ip_on_launch = "true"  #it makes this a public subnet
    availability_zone = var.availability_zone
    
    tags = {
        Name = "Revolut subnet"
    }
}

output "vpc_id" {
  value = aws_vpc.x.id
}

output "subnet_id" {
  value = aws_subnet.s.id
}
