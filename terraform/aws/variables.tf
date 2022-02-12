variable "cidr_list" {
  default = {
    us-east-1 = "172.20.0.0/16"
    us-east-2 = "172.21.0.0/16"
  }
}

variable "cidr_subnet_list" {
  default = {
    "172.20.0.0/16" = "172.20.1.0/24"
    "172.21.0.0/16" = "172.21.1.0/24"
  }
}

variable "ami_list" {
  default = {
    us-east-1 = "ami-07d02ee1eeb0c996c" # Debian 10 ami
    us-east-2 = "ami-089fe97bc00bff7cc" # Debian 10 ami
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

variable "service_ports" {
  type    = list(number)
  default = [22]
}

variable "ansible_inventories" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "appserver_secret_key" {
  type = string
}

variable "dbport" {
  type = number
}

variable "dbname" {
  type = string
}

variable "dbuser" {
  type = string
}

variable "dbpass" {
  type = string
}

variable "dbappname" {
  type = string
}

variable "haproxy_conf" {
  type = string
}

variable "haproxy_user" {
  type = string
}

variable "haproxy_pass" {
  type = string
}

variable "terraform_access_key" {
  type = string
}

variable "terraform_secret_key" {
  type = string
}
