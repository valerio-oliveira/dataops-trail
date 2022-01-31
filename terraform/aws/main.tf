terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

resource "aws_vpc_peering_connection" "peering_conn" {
  provider    = aws.us-east-1
  peer_region = module.replica.current_region_name
  peer_vpc_id = module.replica.vpc_id
  vpc_id      = module.main.vpc_id
}

module "main" {
  source            = "./per-region"
  providers         = { aws = aws.us-east-1 }
  availability_zone = "us-east-1a"
  is_main_region    = 1
  application_ports = var.application_ports
  database_ports    = var.database_ports
  cidr_list         = var.cidr_list
  cidr_subnet_list  = var.cidr_subnet_list
  ami_list          = var.ami_list
  ssh_public_key    = var.ssh_public_key
  peering_conn_id   = aws_vpc_peering_connection.peering_conn.id
}

module "replica" {
  source            = "./per-region"
  providers         = { aws = aws.us-east-2 }
  availability_zone = "us-east-2a"
  application_ports = var.application_ports
  database_ports    = var.database_ports
  cidr_list         = var.cidr_list
  cidr_subnet_list  = var.cidr_subnet_list
  ami_list          = var.ami_list
  ssh_public_key    = var.ssh_public_key
  peering_conn_id   = aws_vpc_peering_connection.peering_conn.id
}

resource "aws_vpc_peering_connection_accepter" "peering_conn_accepter" {
  provider                  = aws.us-east-2
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_conn.id
  auto_accept               = true
}
