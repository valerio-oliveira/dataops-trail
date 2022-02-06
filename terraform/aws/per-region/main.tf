terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

data "aws_region" "current" {}

resource "aws_key_pair" "ssh_key" {
  #  provider   =                    aws_region.current
  key_name   = "aws"
  public_key = file(var.ssh_public_key)
}

resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.cidr_list[data.aws_region.current.name]
  enable_dns_support   = "true" # internal dosite1 name
  enable_dns_hostnames = "true" # internal host name

  tags = {
    Name = "production_vpc"
  }
}

module "security" {
  source            = "../security"
  application_ports = var.application_ports
  database_ports    = var.database_ports
  service_ports     = var.service_ports
  current_vpc_id    = aws_vpc.prod_vpc.id
}

resource "aws_internet_gateway" "prod_gateway" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "production_gateway"
  }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = var.cidr_subnet_list[aws_vpc.prod_vpc.cidr_block]
  map_public_ip_on_launch = "true" # it makes this a public subnet
  availability_zone       = var.availability_zone

  tags = {
    Name = "production_subnet"
  }
}

resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # associated subnet can reach everywhere
    gateway_id = aws_internet_gateway.prod_gateway.id
  }

  dynamic "route" {
    for_each = {
      for region, value in var.cidr_list : region => value
      if value != var.cidr_list[data.aws_region.current.name]
    }
    content {
      cidr_block                = route.value
      vpc_peering_connection_id = var.peering_conn_id
    }
  }

  tags = {
    Name = "production_route_table"
  }
}
resource "aws_route_table_association" "requesting_route_table_subnet" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.prod_route_table.id
}

module "vm_application" {
  source            = "../vm"
  ami               = var.ami_list[data.aws_region.current.name]
  security_group    = module.security.application_group_id
  vm_name           = "vm_application"
  current_vpc_id    = aws_vpc.prod_vpc.id
  current_subnet_id = aws_subnet.prod_subnet.id
  key_name          = aws_key_pair.ssh_key.key_name
}

module "vm_database" {
  source            = "../vm"
  ami               = var.ami_list[data.aws_region.current.name]
  security_group    = module.security.database_group_id
  vm_name           = "vm_database"
  current_vpc_id    = aws_vpc.prod_vpc.id
  current_subnet_id = aws_subnet.prod_subnet.id
  key_name          = aws_key_pair.ssh_key.key_name
}

module "vm_service" {
  source            = "../vm"
  ami               = var.ami_list[data.aws_region.current.name]
  security_group    = module.security.application_group_id
  vm_name           = "vm_service"
  current_vpc_id    = aws_vpc.prod_vpc.id
  current_subnet_id = aws_subnet.prod_subnet.id
  key_name          = aws_key_pair.ssh_key.key_name
}
