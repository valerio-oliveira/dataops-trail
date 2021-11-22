output "api_public_ip" {
  value = module.apis.*.public_ip
}

output "api_public_dns" {
  value = module.apis.*.public_dns
}

output "db_public_ip" {
  value = module.databases.*.public_ip
}

output "db_public_dns" {
  value = module.databases.*.public_dns
}
