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
  }
]
