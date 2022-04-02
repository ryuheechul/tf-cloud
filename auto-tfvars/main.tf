# should be at variables.tf
variable "deploy_name" {
  type = string
}

variable "per_deploy" {
  type = list(object({
    deploy = string
    object_example = object({
      entry1 = string
      entry2 = string
    })
    list_example = list(string)
  }))

  default = [
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
    }
  ]
}

locals {

  # turns
  # ```hcl
  # [
  #   {
  #     deploy = "example"
  #     object_example = {
  #       entry1 = "example-entry1"
  #     }
  #     list_example = [
  #       "1",
  #       "2"
  #     ]
  #   }
  # ]
  # ```
  # to
  # ```hcl
  # {
  #   "example": {
  #     deploy = "example"
  #     object_example = {
  #       entry1 = "example-entry1"
  #     }
  #     list_example = [
  #       "1",
  #       "2"
  #     ]
  #   }
  # }
  # ```
  deploys = {
    for obj in var.per_deploy : obj.deploy => obj
  }
  deploy = local.deploys[var.deploy_name]
}

# should be at outputs.tf
output "result" {
  value = local.deploy
}
