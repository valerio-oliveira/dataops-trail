output "public_ip" {
  value = aws_instance.api-host.public_ip
}

output "private_ip" {
  value = aws_instance.api-host.private_ip
}

output "public_dns" {
  value = aws_instance.api-host.public_dns
}
