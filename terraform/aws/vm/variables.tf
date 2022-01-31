variable "key_name" {
  type = string
}

variable "ami" {}

variable "security_group" {
  type = string
}

variable "current_vpc_id" {
  type = string
}

variable "current_subnet_id" {
  type = string
}

variable "vm_name" {
  type = string
}
