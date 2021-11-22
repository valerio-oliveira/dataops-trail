variable "vm_connetion_ports_api" {
  type    = list(number)
  default = [22]
}

variable "vm_connetion_ports_db" {
  type    = list(number)
  default = [22]
}
variable "username" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_private_key" {
  type = string
}

# variable "ssh_public_key" {
#   type    = string
#   default = "~/.ssh/aws.pub"
# }

variable "sec_group_name" {
  type = string
}

variable "counter" {
  type    = number
  default = 1
}

variable "num_of_instances" {
  type    = number
  default = 1
}

variable "provider_access_key" {
  type = string
}

variable "provider_secret_key" {
  type = string
}
