variable "private_key" {
  description = "SSH private key for provisioner"
  type        = string
}

variable "vm_connetion_ports" {
  description = "Ports to connect"
  type        = list(number)
  default     = [22]
}

variable "username" {
  description = "username for provisioner ssh connection"
  type        = string
}

variable "counter" {
  type = number
}

variable "ssh_key_name" {
  type = string
}

variable "sec_group_name" {
  type = string
}
