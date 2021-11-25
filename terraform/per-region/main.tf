terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" { }

variable "cidr" {}
variable "security_ports" {
  type    = list(number)
  default = [22]
}

module "vpc" {
  source = "../vpc"
  cidr = var.cidr[data.aws_region.current.name]
}

module "security" {
  source = "../security"
  security_ports = var.security_ports
  current_vpc_id = module.vpc.vpc_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
