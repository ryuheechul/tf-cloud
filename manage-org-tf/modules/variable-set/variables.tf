variable "name" {
  description = "for tfe_variable_set"
  type        = string
}

variable "description" {
  description = "for tfe_variable_set"
  type        = string
}

variable "organization" {
  description = "for tfe_variable_set"
  type        = string
}

variable "workspace_ids" {
  description = "for tfe_variable_set"
  type        = list(string)
}

variable "vars" {
  description = "for list of tfe_variable"
  type = list(object({
    category  = optional(string)
    key       = string
    value     = string
    sensitive = optional(bool)
  }))
}
