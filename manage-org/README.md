# manage-org
Why not manage Terraform Cloud using itself!

## Minimal Manual Bootstrap

- create an organization manually and create `manage-org` workspace
- follow the steps at [this guide](https://learn.hashicorp.com/tutorials/terraform/github-oauth?in=terraform/cloud) to link github and TFC.
- provide values for bootstrapping necessary vars by [bin/inject-vars.sh](./bin/inject-vars.sh) including:
  - set `organization` to the one created from previous step
  - set `workspace` to `manage-org`
  - set `tfc_oauth_client_id` to by visiting `https://app.terraform.io/app/[your-org]/settings/version-control`
    - click `Edit Client`
    - extract the client id that starts from `oc-` (either in the address bar or breadcrumb)
  - set `TFE_TOKEN` value (by creating (not org) api token from Terraform Cloud)
- change execution mode to Remote (but leave Manual apply for safety)
- Settings > Version Control > Version Control Workflow to connect this repo - Choose Github (Custom) to use the integration from the first step above.
- set `manage-org/cdktf.out/stacks/manage-org` to Terraform Working Directory

## Prerequisites

This can be managed automatically via [direnv](../.envrc) and [nix](../shell.nix).

## Starting Point
[main.ts](./main.ts)

Also don't forget to run `make synth` and commit the changes of [cdktf.out](./cdktf.out)
> maybe I should add this to a pre-commit hook

## Gotchas
Somtimes trivial changes could take forever (and end up fail).

This could just be Terraform Cloud's internal issue (cyclic dependency on processing or some other issues) that may only occur via Terraform (or API) execution

A practical remidiation would be just make the change from the plan manually and plan again until there is nothing to apply.
