
resource "aws_security_group" "ec2_ports_api" {
  name = var.security_group_name_api

  dynamic "ingress" {
    for_each = var.conn_ports_api
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name_api
  }
}

resource "aws_security_group" "ec2_ports_db" {
  name = var.security_group_name_db

  dynamic "ingress" {
    for_each = var.conn_ports_db
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name_db
  }
}
