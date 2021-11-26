variable "cidr_list" {
  default = {
    us-east-1 = "172.20.0.0/24"
    us-east-2 = "172.20.1.0/24"
  }
}

variable "security_ports" {
  type    = list(number)
  default = [22]
}

variable "ansible_directory" {
  type = string
}
