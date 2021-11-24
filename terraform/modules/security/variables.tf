
variable "conn_ports_api" { type = list(number) }

variable "conn_ports_db" { type = list(number) }

variable "security_group_name_api" { type = string }
variable "security_group_name_db" { type = string }
