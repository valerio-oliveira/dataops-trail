provider "aws" {
  profile    = var.profile
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "revolut_vpc" {
  cidr_block = format("%s.0.0/16", var.vpc_prefix)

  tags = { Name = "revolut_vpc" }
}

resource "aws_subnet" "revolut_subnet" {
  vpc_id            = aws_vpc.revolut_vpc.id
  cidr_block        = format("%s.0/24", var.subnet_prefix)
  availability_zone = format("%s.%s", var.region, "a")

  tags = { Name = "revolut_subnet_main" }
}

module "apis" {
  source              = "../apis"
  ec2_instance_type   = var.ec2_instance_type
  ami_linux_distro    = var.ami_linux_distro
  security_group_name = var.security_group_name_api
  subnet_id           = aws_subnet.revolut_subnet.id
  ipv4_address        = format("%s.%s", var.subnet_prefix, "6")
  ssh_key_name        = var.ssh_key_name
}

module "databases" {
  source              = "../databases"
  ec2_instance_type   = var.ec2_instance_type
  ami_linux_distro    = var.ami_linux_distro
  security_group_name = var.security_group_name_db
  subnet_id           = aws_subnet.revolut_subnet.id
  ipv4_address        = format("%s.%s", var.subnet_prefix, "12")
  ssh_key_name        = var.ssh_key_name
}
