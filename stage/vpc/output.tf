output "vpc" {
    value = module.vpc
}

output "public_subnets" {
    value = module.vpc.public_subnets
}