output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnet_ids" {
    value = aws_subnet.cluster_public_subnets[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.cluster_private_subnets[*].id
}
