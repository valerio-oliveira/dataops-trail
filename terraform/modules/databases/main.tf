resource "aws_network_interface" "db-interface" {
  subnet_id   = var.subnet_id
  private_ips = [var.ipv4_address]

  tags = {
    Name = "db-interface"
  }
}

resource "aws_instance" "db-host" {
  ami             = var.ami_linux_distro
  key_name        = var.ssh_key_name
  instance_type   = var.ec2_instance_type
  security_groups = [var.security_group_name]

  network_interface {
    network_interface_id = aws_network_interface.db-interface.id
    device_index         = 0
  }

  tags = {
    Name = "db-host"
  }
}
