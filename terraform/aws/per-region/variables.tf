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

variable "cidr_list" {}

variable "cidr_subnet_list" {}

variable "ami_list" {}

variable "availability_zone" {
  type = string
}

variable "is_main_region" {
  type    = number
  default = 0
}

variable "ssh_public_key" {
  type = string
}

variable "peering_conn_id" {}
