output "name" {
  value = var.name
}

output "workspace_name" {
  value = var.workspace_name
}

output "workspace_id" {
  value = tfe_workspace.workspace.id
}
