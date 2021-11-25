terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

variable "cidr" {}

resource "aws_vpc" "x" {
  cidr_block = var.cidr
  tags = { Name = "created by terraform" }
}

output "vpc_id" {
  value = aws_vpc.x.id
}