output "variable_set" {
  value = tfe_variable_set.varset
}

output "workspace_ids" {
  value = tfe_variable_set.varset.workspace_ids
}
