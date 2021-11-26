terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

variable "cidr_list" {}

variable "security_ports" {
  type    = list(number)
  default = [22]
}

variable "ansible_directory" {
  type = string
}

module "net" {
  source            = "../net"
  cidr_block        = var.cidr_list[data.aws_region.current.name]
  availability_zone = format("%s%s", data.aws_region.current.name, "a")
}

module "security" {
  source         = "../security"
  security_ports = var.security_ports
  current_vpc_id = module.net.vpc_id
}

module "vm_database" {
  source            = "../vm"
  sec_group_name    = module.security.security_group_id
  vm_name           = "vm_database"
  current_vpc_id    = module.net.vpc_id
  current_subnet_id = module.net.subnet_id
}
