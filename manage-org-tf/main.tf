# # this just makes local testing inconvenient
# # all the reference it give is only the same value, `data.tfe_organization.org.name` anyway
# # so just use `var.tfc_organization`
# data "tfe_organization" "org" {
#   name = var.tfc_organization
# }

locals {
  workspace_bundles = defaults(var.workspace_bundles, {
    deploys = {
      structured_run_output_enabled = true
      auto_apply                    = true
      # we can't do this yet - https://github.com/hashicorp/terraform/issues/28406
      # tags                          = []
    }
  })
}

# this + ./bundles.auto.tfvars can be comparable to ../manage-org/main.ts
module "ws_bundles" {
  source = "./modules/workspace-bundle"

  # need to use `local` instead of `var` to take effect on defaults - https://www.terraform.io/language/functions/defaults
  for_each = local.workspace_bundles
  #      each.key = each.value
  # --------------------------
  # "bundle-name" = {
  #   "deploy-name" = {
  #     working_directory = "working/directory"
  #     vars = {
  #       ...
  #     }
  #   }
  # }

  bundle       = each.value
  prefix       = each.key
  organization = var.tfc_organization
}

# default convinient variables that will help each workspace to access metadata
resource "tfe_variable_set" "for_all" {
  name         = "Common Varset"
  description  = ""
  organization = var.tfc_organization
  workspace_ids = [
    for workspace in flatten([
      for bundle in module.ws_bundles : bundle.workspaces
    ]) : workspace.id
  ]
}

resource "tfe_variable" "varset_test" {
  category        = "terraform"
  key             = "test"
  value           = "test var set var 1"
  sensitive       = false
  variable_set_id = tfe_variable_set.for_all.id
}

resource "tfe_variable" "varset_test2" {
  category        = "env"
  key             = "TEST2"
  value           = "test var set var 2"
  sensitive       = false
  variable_set_id = tfe_variable_set.for_all.id
}
