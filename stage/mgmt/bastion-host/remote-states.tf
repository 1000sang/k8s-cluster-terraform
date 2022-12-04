data "tfe_outputs" "this" {
    for_each = local.config.remote_states

    organization = each.value.organization
    workspace = each.value.workspace
}