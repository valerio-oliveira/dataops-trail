terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" { }

variable "cidr_list" {  }

# variable "ssh_key_name" { type = string }

variable "security_ports" {
  type    = list(number)
  default = [22]
}

module "vpc" {
  source = "../vpc"
  cidr_block = var.cidr_list[data.aws_region.current.name]
  availability_zone = format("%s%s", data.aws_region.current.name, "a")
}

module "security" {
  source = "../security"
  security_ports = var.security_ports
  current_vpc_id = module.vpc.vpc_id
}

module "vm_database" {
  source = "../vm"
  #ssh_key_name = var.ssh_key_name
  #ssh_public_key = 
  sec_group_name = module.security.security_group_id
  vm_name = "Revolut vm_database"
  current_vpc_id = module.vpc.vpc_id
  current_subnet_id = module.vpc.subnet_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
