workspace_bundles = {
  "auto-tfvars" = {
    # this is where you specify which repo you are using for this bundle
    repo = "ryuheechul/tf-cloud"
    deploys = {
      "staging" = {
        # TFC will read and deploy from this directory from the repo above
        working_directory = "auto-tfvars"
      }
      "another-env" = {
        working_directory = "auto-tfvars"
        # optionally specify the branch - in this particular case this doesn't change anything as the default branch (when you don't provide) is already "main"
        # but it's here to demonstrate that you can specify
        branch = "main"
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
