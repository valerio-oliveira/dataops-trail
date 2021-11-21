output "apihost_private_ip" {
  value = aws_instance.apihost.private_ip
}

output "apihost_public_ip" {
  value = aws_instance.apihost.public_ip
}

output "apihost_public_dns" {
  value = aws_instance.apihost.public_dns
}

output "dbhost01_private_ip" {
  value = aws_instance.dbhost01.private_ip
}

output "dbhost01_public_ip" {
  value = aws_instance.dbhost01.public_ip
}

output "dbhost01_public_dns" {
  value = aws_instance.dbhost01.public_dns
}

