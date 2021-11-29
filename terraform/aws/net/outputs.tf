output "vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "subnet_id" {
  value = aws_subnet.prod_subnet.id
}
