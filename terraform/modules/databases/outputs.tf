output "public_ip" {
  value = aws_instance.db-host.public_ip
}

output "private_ip" {
  value = aws_instance.db-host.private_ip
}

output "public_dns" {
  value = aws_instance.db-host.public_dns
}
