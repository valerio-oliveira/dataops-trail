variable "cidr_list" {
  default = {
    us-east-1 = "172.20.1.0/24"
    us-east-2 = "172.20.2.0/24"
  }
}

variable "ami_list" {
  default = {
    us-east-1 = "ami-07d02ee1eeb0c996c"
    us-east-2 = "ami-089fe97bc00bff7cc"
  }
}

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
