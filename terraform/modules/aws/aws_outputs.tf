output "api_public_ip" {
  value = module.apis.*.public_ip
}

output "api_public_dns" {
  value = module.apis.*.public_dns
}

output "db_privare_ip" {
  value = module.databases.*.private_ip
}

output "db_public_ip" {
  value = module.databases.*.public_ip
}

output "db_public_dns" {
  value = module.databases.*.public_dns
}

output "subnet_id" { value = aws_subnet.revolut_subnet.id }
