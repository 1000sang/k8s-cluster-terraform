output "cluster" {
  value = module.eks
}

output "name" {
  value = module.eks.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "role_arn" {
    value = module.lb_role.iam_role_arn
}