locals {
  cluster = yamldecode(file(var.config_file)).cluster
}

locals {
  context = yamldecode(file(var.config_file)).context
  config  = yamldecode(templatefile(var.config_file, local.context))
}

locals {
  remote_states = {
    "network" = data.tfe_outputs.network.values
  }

  public_subnet_ids = local.remote_states["network"].public_subnet_ids
  private_subnet_ids = local.remote_states["network"].private_subnet_ids
  vpc_id = local.remote_states["network"].vpc_id
}