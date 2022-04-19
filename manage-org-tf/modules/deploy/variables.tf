variable "name" {
  description = "name for deploy. ex) dev, stag, prod, etc."
  type        = string
}

variable "workspace_name" {
  description = "workspace name. ex)[bundle-name]-[deploy-name]"
  type        = string
}

variable "organization" {
  description = "organization name for Terraform Cloud"
  type        = string
}

variable "deploy" {
  description = "this is the meat"
  type = object({
    working_directory = string
    # this doesn't have to be optional here since it's taken care at the root level
    structured_run_output_enabled = bool
    tags                          = list(string)
    auto_apply                    = bool
    repo = object({
      identifier = string
      branch     = optional(string)
    })
    extra_vars = map(object({
      value     = string
      sensitive = bool
    }))
  })
}

variable "oauth_token_id" {
  description = "to connect with VCS (github) provider"
  type        = string
}
