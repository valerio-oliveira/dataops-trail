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

variable "ami_list" {}

variable "application_ports" {
  type    = list(number)
  default = [22]
}

variable "database_ports" {
  type    = list(number)
  default = [22]
}

variable "ansible_directory" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

module "net" {
  source            = "../net"
  cidr_block        = var.cidr_list[data.aws_region.current.name]
  availability_zone = format("%s%s", data.aws_region.current.name, "a")
}

module "security" {
  source            = "../security"
  application_ports = var.application_ports
  database_ports    = var.database_ports
  current_vpc_id    = module.net.vpc_id
}

# module "vm_application" {
#   source            = "../vm"
#   security_group    = module.security.application_group_id
#   vm_name           = "vm_application"
#   current_vpc_id    = module.net.vpc_id
#   current_subnet_id = module.net.subnet_id
# }

module "vm_database" {
  source            = "../vm"
  ami               = var.ami_list[data.aws_region.current.name]
  security_group    = module.security.database_group_id
  vm_name           = "vm_database"
  current_vpc_id    = module.net.vpc_id
  current_subnet_id = module.net.subnet_id
  ssh_public_key    = var.ssh_public_key
}
