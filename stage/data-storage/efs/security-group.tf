resource "aws_security_group" "this" {
  description = "Test EFS security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "2049"
    protocol    = "tcp"
    self        = "false"
    to_port     = "2049"
  }

  name   = local.security_group.name
  vpc_id = local.vpc_id
}