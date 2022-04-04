workspace_bundles = {
  "auto-tfvars" = {
    deploys = {
      "staging" = {
        working_directory = "auto-tfvars"
        vars              = {} # leave it empty when not necessary
      }
      "another-env" = {
        working_directory = "auto-tfvars"
        vars = {
          "extra_var" = {
            value     = "extra value for extra_var"
            sensitive = false
          }
        }
      }
    }
  }
}
