output "current_region_id" {
  value = data.aws_region.current.id
}
output "current_region_name" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = aws_vpc.prod_vpc.id
}
output "route_table_id" {
  value = aws_route_table.prod_route_table.id
}

output "vpc_cidr_block" {
  value = aws_vpc.prod_vpc.cidr_block
}

output "gateway_id" {
  value = aws_internet_gateway.prod_gateway.id
}

output "subnet_id" {
  value = aws_subnet.prod_subnet.id
}

output "application_security_group_id" {
  value = module.security.application_group_id
}

# ------------------------

output "database_data" {
  value = {
    "private_dns" : module.vm_database.private_dns
    "private_ip" : module.vm_database.private_ip,
    "public_dns" : module.vm_database.public_dns,
    "public_ip" : module.vm_database.public_ip,
  }
}

output "application_data" {
  value = {
    "private_dns" : module.vm_application.private_dns
    "private_ip" : module.vm_application.private_ip,
    "public_dns" : module.vm_application.public_dns,
    "public_ip" : module.vm_application.public_ip,
  }
}

output "service_data" {
  value = {
    "private_dns" : module.vm_service.private_dns
    "private_ip" : module.vm_service.private_ip,
    "public_dns" : module.vm_service.public_dns,
    "public_ip" : module.vm_service.public_ip,
  }
}
