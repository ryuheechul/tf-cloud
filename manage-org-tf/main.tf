# # this just makes local testing inconvenient
# # all the reference it give is only the same value, `data.tfe_organization.org.name` anyway
# # so just use `var.tfc_organization`
# data "tfe_organization" "org" {
#   name = var.tfc_organization
# }

locals {
  # don't get confused - this from a var so it doesn't depends on actual applying
  workspace_bundles = defaults(var.workspace_bundles, {
    deploys = {
      structured_run_output_enabled = true
      auto_apply                    = true
      # we can't do this yet - https://github.com/hashicorp/terraform/issues/28406
      # but empty list seems to be the default anyway
      # tags                          = []
      #
      # we can't do this yet - https://github.com/hashicorp/terraform/issues/28406
      # but empty map seems to be the default anyway
      # extra_vars                    = {}
    }
  })

  # but this one depends on module.ws_bundles so it's only known after apply
  all_workspaces = flatten([
    for bundle in module.ws_bundles : bundle.workspaces
  ])

  workspaces_with_tag_exclusive = [
    for workspace in local.all_workspaces : workspace
    if contains(workspace.tag_names, "varset-exclusive")
  ]
}

data "tfe_oauth_client" "github" {
  oauth_client_id = var.tfc_oauth_client_id
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
  #     extra_vars = {
  #       ...
  #     }
  #   }
  # }

  bundle         = each.value
  prefix         = each.key
  organization   = var.tfc_organization
  oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

# imagine default convinient variables that will help each workspace to have some metadata
module "varset_for_all" {
  source = "./modules/variable-set"

  name         = "A common Varset"
  description  = ""
  organization = var.tfc_organization
  workspace_ids = [
    for workspace in local.all_workspaces : workspace.id
  ]

  vars = [
    {
      key   = "test"
      value = "test var set var 1"
    },
    {
      category = "env"
      key      = "TEST2"
      value    = "test var set var 2"
    }
  ]
}

# Why do this? Imagine setting `aws-dev`, `aws-prod` tags and sets the whatever vars necessary to differentiate the deploy (env).
# It could be credentials or anything else
module "varset_only_for_exclusive_tag" {
  source = "./modules/variable-set"

  name         = "An exclusive varset"
  description  = "Exclusive Varset for workspaces that has `varset-exclusive`"
  organization = var.tfc_organization
  workspace_ids = [
    for workspace in local.workspaces_with_tag_exclusive : workspace.id
  ]

  vars = [
    {
      key   = "why"
      value = "because of the workspace has `varset-exclusive` tag"
    },
    {
      key   = "how"
      value = "this is not something that comes for free by TFC, it's what's written by the root module"
    }
  ]
}
