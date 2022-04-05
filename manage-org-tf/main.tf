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
