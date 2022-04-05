terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.30.1"
    }
  }
}
