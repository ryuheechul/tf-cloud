# should be at variables.tf
variable "deploy_name" {
  type = string
}

variable "per_deploy" {
  # because it's list any number of deploys can be added and they all need to follow this type
  type = list(object({
    deploy = string
    object_example = object({
      entry1 = string
      entry2 = string
    })
    list_example = list(string)
  }))

  default = [
    # deploy 1
    {
      deploy = "example"
      object_example = {
        entry1 = "example-entry1"
        entry2 = "example-entry2"
      }
      list_example = [
        "1",
        "2"
      ]
    },
    # deploy 2
    # {
    #   ...
    # }
  ]
}

locals {
  # turns
  # ```hcl
  # [
  #   {
  #     deploy = "example"
  #     ...
  #   }
  # ]
  # ```
  # to
  # ```hcl
  # {
  #   "example": {
  #     deploy = "example"
  #     ...
  #   }
  # }
  # ```
  deploys = {
    for obj in var.per_deploy : obj.deploy => obj
  }

  # finally the values that corresponds to deploy
  deploy = local.deploys[var.deploy_name]
}

# should be at outputs.tf
output "debug_var_deploy_name" {
  value = var.deploy_name
}

output "debug_var_per_deploy" {
  value = var.per_deploy
}

output "debug_local_deploy" {
  value = local.deploy
}
