
output "application_group_id" {
  value = resource.aws_security_group.application_group.id
}
output "database_group_id" {
  value = resource.aws_security_group.database_group.id
}
