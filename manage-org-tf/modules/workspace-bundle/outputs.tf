output "name" {
  value = var.prefix
}

output "workspace_names" {
  value = [
    for deploy in module.deploys : deploy.workspace_name
  ]
}

output "workspace_ids" {
  value = [
    for deploy in module.deploys : deploy.workspace_id
  ]
}
