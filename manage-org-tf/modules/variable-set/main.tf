terraform {
  # for `optional` at ./variables.tf
  experiments = [module_variable_optional_attrs]
}

locals {
  vars = defaults(var.vars, {
    category  = "terraform"
    sensitive = false
  })
}

resource "tfe_variable_set" "varset" {
  name          = var.name
  description   = var.description
  organization  = var.organization
  workspace_ids = var.workspace_ids
}

resource "tfe_variable" "var_in_set" {

  # because `for_each = local.vars` wouldn't work
  for_each = { for var_ in local.vars : var_.key => var_ }

  category  = each.value.category
  key       = each.value.key
  value     = each.value.value
  sensitive = each.value.sensitive

  variable_set_id = tfe_variable_set.varset.id
}
