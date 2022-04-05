output "bundles" {
  value = {
    for bundle in module.ws_bundles : bundle.name => { workspaces = bundle.workspace_names }
  }
}

output "debug_var_workspace_bundles" {
  value = var.workspace_bundles
}

output "debug_local_workspace_bundles" {
  value = local.workspace_bundles
}
