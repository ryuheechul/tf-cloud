output "name" {
  value = var.prefix
}

output "workspaces" {
  value = [
    for deploy in module.deploys : deploy.workspace
  ]
}
