# different deploy (aka env) values can be together in one separate file

per_deploy = [
  {
    deploy = "dev"
    object_example = {
      entry1 = "dev-entry1"
      entry2 = "dev-entry2"
    }
    list_example = [
      "1",
    ]
  },
  {
    deploy = "staging"
    object_example = {
      entry1 = "staging-entry1"
      entry2 = "staging-entry2"
    }
    list_example = [
      "1",
      "2",
    ]
  },
  {
    deploy = "prod"
    object_example = {
      entry1 = "prod-entry1"
      entry2 = "prod-entry2"
    }
    list_example = [
      "1",
      "2",
      "3",
    ]
  },
  {
    deploy         = "another-env"
    object_example = {
      entry1 = "entry1"
      entry2 = "entry2"
    }
    list_example   = []
  }
]

# if you wish to have each deploy values on its own file, ex) `dev.auto.tfvars`, `prod.autotfvars`, that seems to be impossible with `tfvars`
# however we can always render a `deploy.auto.tfvars.json` from `dev.deploy.json` and `prod.deploy.json`

# dev.deploy.json
# {
#   "deploy": "dev",
#   ...
# }
#
# prod.deploy.json
# {
#   "deploy": "prod",
#   ...
# }
#
# run `jq -s '[.[0], .[1]]' dev.deploy.json prod.deploy.json`
# look an example at `./compile`
