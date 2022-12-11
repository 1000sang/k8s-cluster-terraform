data "tfe_outputs" "network" {
    organization = "devfloors"
    workspace = "terraform-k8s-boilerplate"
}

data "tfe_outputs" "role" {
    organization = "devfloors"
    workspace = "terraform-k8s-boilerplate-cluster-role"
}