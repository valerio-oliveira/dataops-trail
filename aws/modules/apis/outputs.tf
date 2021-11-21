output "apihost_private_ip" {
  value = aws_instance.apihost.private_ip
}

output "apihost_public_ip" {
  value = aws_instance.apihost.public_ip
}

output "apihost_public_dns" {
  value = aws_instance.apihost.public_dns
}
