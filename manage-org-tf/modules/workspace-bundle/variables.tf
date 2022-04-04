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
      vars = map(object({
        value     = string
        sensitive = bool
      }))
    }))
  })
}
