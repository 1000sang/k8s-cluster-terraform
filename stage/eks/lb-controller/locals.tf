locals {
  remote_states = {
    "cluster" = data.tfe_outputs.cluster.values
    "network" = data.tfe_outputs.network.values
  }

  cluster_name = local.remote_states["cluster"].name
  cluster_endpoint = local.remote_states["cluster"].cluster_endpoint
  oidc_provider_arn = local.remote_states["cluster"].oidc_provider_arn

  vpc_id = local.remote_states["network"].vpc_id
}