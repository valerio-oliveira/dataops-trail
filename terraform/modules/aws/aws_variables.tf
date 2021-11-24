variable "profile" { type = string }
variable "region" { type = string }
variable "ssh_key_name" { type = string }
variable "aws_access_key" { type = string }
variable "aws_secret_key" { type = string }
variable "security_group_name_api" { type = string }
variable "security_group_name_db" { type = string }

variable "ec2_instance_type" { type = string }
variable "vpc_prefix" { type = string }
variable "subnet_prefix" { type = string }
variable "ami_linux_distro" { type = string }


