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
