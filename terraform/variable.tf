variable "cidr" {
  default = {
    us-east-1 = "172.20.0.0/24"
    us-east-2 = "172.20.1.0/24"
  }
}

variable "database_ports" {
  type    = list(number)
  default = [22, 5432]
}

variable "application_ports" {
  type    = list(number)
  default = [22, 5432]
}
