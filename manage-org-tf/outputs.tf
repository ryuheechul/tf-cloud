output "bundles" {
  value = module.ws_bundles
}

output "debug_var_workspace_bundles" {
  value = var.workspace_bundles
}

output "debug_local_workspace_bundles" {
  value = local.workspace_bundles
}

output "debug_local_workspaces_with_tag_exclusive" {
  value = local.workspaces_with_tag_exclusive
}

output "debug_module_varset_only_for_exclusive_tag_workspace_ids" {
  value = module.varset_only_for_exclusive_tag.workspace_ids
}
