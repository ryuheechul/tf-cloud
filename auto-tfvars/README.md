# auto-tfvars
A simple terraform project that tests `*.auto.tfvars` files being loaded to TFC

## Debug
Simply run `make` locally and enter either `dev` or `prod` for `deploy_name`

## Watch Out for `.gitignore`
Make sure `*.auto.tfvars` are not ignored by `.gitignore`

```diff
  *.tfvars
  *.tfvars.json
+ !*.auto.tfvars       # if there is lines like above
+ !*.auto.tfvars.json  # add these two lines to make exception for `*.auto.tfvars[.json]`
```
