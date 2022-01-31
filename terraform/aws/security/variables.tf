variable "application_ports" {
  type    = list(number)
  default = [22]
}

variable "database_ports" {
  type    = list(number)
  default = [22]
}

variable "current_vpc_id" {
  type = string
}

