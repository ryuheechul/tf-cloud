workspace_bundles = {
  "auto-tfvars" = {
    deploys = {
      "staging" = {
        working_directory = "auto-tfvars"
      }
      "another-env" = {
        working_directory = "auto-tfvars"
        # this is optional and I'm turning it off only in this deploy
        structured_run_output_enabled = false
        tags = [
          "random-tag",
          "varset-exclusive"
        ]
        auto_apply = false
        extra_vars = {
          "extra_var" = {
            value     = "extra value for extra_var"
            sensitive = false
          }
        }
      }
    }
  }
}
