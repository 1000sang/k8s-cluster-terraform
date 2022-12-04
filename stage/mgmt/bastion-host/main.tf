module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = local.config.instance_name

  ami                    = local.config.ami
  instance_type          = "t2.micro"
  key_name               = local.config.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = local.remote_states["network"].public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}