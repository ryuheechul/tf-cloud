output "bundles" {
  value = {
    for bundle in module.ws_bundles : bundle.name => bundle.workspace_names
  }
}
