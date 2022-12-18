locals {
  security_group = yamldecode(file(var.config_file)).security_group
}

locals {
  remote_states = {
    "network" = data.tfe_outputs.network.values
  }

  public_subnet_ids = local.remote_states["network"].public_subnet_ids
  private_subnet_ids = local.remote_states["network"].private_subnet_ids
  vpc_id = local.remote_states["network"].vpc_id
}