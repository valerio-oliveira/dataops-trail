output "public_ip" {
  value = aws_instance.dbhost01.public_ip
}

output "public_dns" {
  value = aws_instance.dbhost01.public_dns
}
