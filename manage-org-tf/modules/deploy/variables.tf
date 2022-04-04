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
    vars = map(object({
      value     = string
      sensitive = bool
    }))
  })
}
