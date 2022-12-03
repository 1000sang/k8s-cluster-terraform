locals {
  common_tags = {
    Project = "project-name"
    Owner = "devfloors"
  }
}

###################################################
# VPC
###################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name = local.config.vpc.name
  cidr = local.config.vpc.cidr

  azs = ["ap-northeast-2a","ap-northeast-2c"]
  private_subnets = local.config.subnet_groups.private.subnet[*].cidr
  public_subnets = local.config.subnet_groups.public.subnet[*].cidr

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # NACL
  manage_default_network_acl = false

  public_dedicated_network_acl = true
  public_inbound_acl_rules = local.config.nacl.public.inbound.*
  public_outbound_acl_rules = local.config.nacl.public.outbound.*
  
  private_dedicated_network_acl = true
  private_inbound_acl_rules = local.config.nacl.private.inbound.*
  private_outbound_acl_rules = local.config.nacl.private.outbound.*

  tags = {
    Terraform = "true"
    Environment = "staging"
  }
}

output "testinbnound2" {
  value = local.config.nacl.public.inbound.*
}
