data "tfe_organization" "org" {
  name = var.tfc_organization
}

# this + ./bundles.auto.tfvars can be comparable to ../manage-org/main.ts
module "ws_bundles" {
  source = "./modules/workspace-bundle"

  for_each = var.workspace_bundles
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
  organization = data.tfe_organization.org.name
}

# default convinient variables that will help each workspace to access metadata
resource "tfe_variable_set" "for_all" {
  name         = "Common Varset"
  description  = ""
  organization = data.tfe_organization.org.name
  workspace_ids = flatten([
    for bundle in module.ws_bundles : bundle.workspace_ids
  ])
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
