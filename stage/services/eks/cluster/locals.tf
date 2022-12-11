locals {
  cluster = yamldecode(file(var.config_file)).cluster
}

locals {
  remote_states = {
    "network" = data.tfe_outputs.network.values
  }

  vpc_id = local.remote_states["network"].vpc_id
  public_subnets = local.remote_states["network"].public_subnets
  private_subnets = local.remote_states["network"].private_subnets
  sg_cluster_id = local.remote_states["network"].sg_cluster_id
}