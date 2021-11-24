terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# data "terraform_remote_state" "aws_global" {
#   backend = "s3"
#   config {
#     region = "us-east-1"
#     bucket = "com.example.bucketname"
#     key = "${var.unixid}/terraform/env/${var.name}/terraform.tfstate"
#   }
# }


module "security" {
  source                  = "./modules/security"
  conn_ports_api          = var.conn_ports_api
  conn_ports_db           = var.conn_ports_db
  security_group_name_api = var.security_group_name_api
  security_group_name_db  = var.security_group_name_db
}

module "aws-region-main" {
  source                  = "./modules/aws"
  profile                 = "default"
  region                  = "us-east-1"
  ec2_instance_type       = var.ec2_instance_type
  vpc_prefix              = format("%s", var.vpc_prefix)
  subnet_prefix           = format("%s.%s", var.vpc_prefix, "1")
  ami_linux_distro        = var.ami_linux_distro
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  ssh_key_name            = var.ssh_key_name
  security_group_name_api = var.security_group_name_api
  security_group_name_db  = var.security_group_name_db
}

module "aws-region-replication" {
  source                  = "./modules/aws"
  profile                 = "default"
  region                  = "us-west-2"
  ec2_instance_type       = var.ec2_instance_type
  vpc_prefix              = format("%s", var.vpc_prefix)
  subnet_prefix           = format("%s.%s", var.vpc_prefix, "2")
  ami_linux_distro        = var.ami_linux_distro
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  ssh_key_name            = var.ssh_key_name
  security_group_name_api = var.security_group_name_api
  security_group_name_db  = var.security_group_name_db
}
