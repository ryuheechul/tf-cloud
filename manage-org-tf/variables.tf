variable "tfc_organization" {
  description = "to be able to set Terraform Cloud Organization name via variable"
  type        = string
}

// this is technically unnecessary because of `terraform.workspace` - https://www.terraform.io/language/expressions/references#filesystem-and-workspace-info
// however `terraform.workspace` is hard to use in `cdktf` yet - https://github.com/hashicorp/terraform-cdk/issues/376
variable "tfc_workspace" {
  description = "to be able to set Terraform Cloud Organization name via variable"
  type        = string
}

# the default value for optional ones is defined at ./main.tf
variable "workspace_bundles" {
  description = "this is the meat"
  type = map(object({
    deploys = map(object({
      working_directory             = string
      structured_run_output_enabled = optional(bool)
      auto_apply                    = optional(bool)
      tags                          = optional(list(string))
      vars = map(object({
        value     = string
        sensitive = bool
      }))
      # TBC
      # vcs = object
    }))
  }))

  # this default is only to illustrate an example
  # look at ./bundles.auto.tfvars for real value
  default = {
    "bundle-name" = {
      deploys = {
        "deploy-name" = {
          working_directory = "working/directory"
          vars = {
            "var_name" = {
              value     = "value-for-var_name"
              sensitive = false
            }
          }
        }
      }
    }
  }
}
