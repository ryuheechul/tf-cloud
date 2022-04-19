module "deploys" {
  source = "../deploy"

  for_each = var.bundle.deploys
  #      each.key = each.value
  # --------------------------
  # "deploy-name" = {
  #   working_directory = "working/directory"
  #   extra_vars = {
  #     "var_name" = {
  #       value     = "value-for-var_name"
  #       sensitive = false
  #     }
  #   }
  # }

  name           = each.key
  workspace_name = "${var.prefix}-${each.key}"
  organization   = var.organization
  deploy         = each.value
  oauth_token_id = var.oauth_token_id
}
