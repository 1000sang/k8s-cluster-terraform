locals {
  remote_states = {
    "cluster" = data.tfe_outputs.cluster.values
    "network" = data.tfe_outputs.network.values
  }

  cluster_name = local.remote_states["cluster"].name
  cluster_endpoint = local.remote_states["cluster"].cluster_endpoint
  role_arn = local.remote_states["cluster"].role_arn  
  vpc_id = local.remote_states["network"].vpc_id
}