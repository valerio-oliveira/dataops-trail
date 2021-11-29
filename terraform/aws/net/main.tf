terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27.0"
    }
  }
}

variable "cidr_block" {}

variable "availability_zone" {
  type = string
}

resource "aws_internet_gateway" "prod_gateway" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "Production gateway"
  }
}

resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name

  tags = {
    Name = "Production vpc"
  }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = "true" #it makes this a public subnet
  availability_zone       = var.availability_zone

  tags = {
    Name = "Production subnet"
  }
}

resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                          # associated subnet can reach everywhere
    gateway_id = aws_internet_gateway.prod_gateway.id # CRT uses this IGW to reach internet
  }

  tags = {
    Name = "Production route table"
  }
}

resource "aws_route_table_association" "prod_route_table_subnet" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.prod_route_table.id
}

#------------------
# resource "aws_route_table" "prod_route_table" {
#   vpc_id = aws_vpc.prod_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"                          # associated subnet can reach everywhere
#     gateway_id = aws_internet_gateway.prod_gateway.id # CRT uses this IGW to reach internet
#   }

#   tags = {
#     Name = "Production route table"
#   }
# }

# resource "aws_route_table_association" "prod_route_table_subnet_1" {
#   subnet_id      = aws_subnet.prod_subnet.id
#   route_table_id = aws_route_table.prod_route_table.id
# }
#------------------
