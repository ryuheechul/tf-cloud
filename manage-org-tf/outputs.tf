output "bundles" {
  value = {
    for bundle in module.ws_bundles : bundle.name => bundle.workspace_names
  }
}

output "debug_var_workspace_bundles" {
  value = var.workspace_bundles
}
