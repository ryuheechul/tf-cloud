resource "tfe_workspace" "workspace" {
  name                          = var.workspace_name
  organization                  = var.organization
  auto_apply                    = var.deploy.auto_apply
  execution_mode                = "remote"
  working_directory             = var.deploy.working_directory
  structured_run_output_enabled = var.deploy.structured_run_output_enabled
  tag_names                     = var.deploy.tags
  lifecycle {
    ignore_changes = [
      vcs_repo
    ]
  }
}

# default convinient variables that will help each workspace to access metadata
resource "tfe_variable" "workspace" {
  category     = "terraform"
  key          = "workspace"
  value        = var.workspace_name
  sensitive    = false
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "deploy_name" {
  category     = "terraform"
  key          = "deploy_name"
  value        = var.name
  sensitive    = false
  workspace_id = tfe_workspace.workspace.id
}

# end of default convinient variables

# extra variables
resource "tfe_variable" "extra_var" {
  for_each = var.deploy.vars
  #   each.key = each.value
  # -------------------------
  # "var_name" = {
  #   value     = "value-for-var_name"
  #   sensitive = false
  # }

  category     = "terraform"
  key          = each.key
  value        = each.value.value
  sensitive    = each.value.sensitive
  workspace_id = tfe_workspace.workspace.id
}
