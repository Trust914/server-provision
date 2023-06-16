resource "aws_security_group" "group-rules" {
  name        = "app-grp-sg"
  description = "app-grp-sg"
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.allow-ports
    iterator = port
    content {
      description = "Allow ${port.key}"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.my-ip]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow ports"
  }
}