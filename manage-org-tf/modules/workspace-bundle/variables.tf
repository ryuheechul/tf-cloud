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
    deploys = map(object({
      working_directory = string
      # this doesn't have to be optional here since it's taken care at the root level
      structured_run_output_enabled = bool
      tags                          = list(string)
      auto_apply                    = bool
      vars = map(object({
        value     = string
        sensitive = bool
      }))
    }))
  })
}
