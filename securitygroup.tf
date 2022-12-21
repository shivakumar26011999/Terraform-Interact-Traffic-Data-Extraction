resource "aws_security_group" "vpc_securitygroup" {
  name        = var.security_group_name #"traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ECS_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}