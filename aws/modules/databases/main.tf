resource "aws_instance" "dbhost01" {
  ami             = "ami-07d02ee1eeb0c996c"
  key_name        = var.ssh_key_name
  instance_type   = "t2.micro"
  security_groups = [var.sec_group_name]
}
