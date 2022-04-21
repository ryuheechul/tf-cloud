variable "prefix" {
  description = "it's a bundle name that prefix workspaces underneath. ex)[prefix]-[deploy-name]"
  type        = string
}

variable "organization" {
  description = "organization name for Terraform Cloud"
  type        = string
}

variable "bundle" {
  description = "this is the meat"
  type = object({
    repo = string
    deploys = map(object({
      working_directory = string
      branch            = string
      # this doesn't have to be optional here since it's taken care at the root level
      structured_run_output_enabled = bool
      tags                          = list(string)
      auto_apply                    = bool
      extra_vars = map(object({
        value     = string
        sensitive = bool
      }))
    }))
  })
}

variable "oauth_token_id" {
  description = "to connect with VCS (github) provider"
  type        = string
}
