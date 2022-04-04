output "name" {
  value = var.prefix
}

output "workspace_names" {
  value = [
    for deploy in module.deploys : deploy.workspace_name
  ]
}
