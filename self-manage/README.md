# self-manage
Why not manage Terraform Cloud using itself!

## Minimal Manual Bootstrap
- provide `TFE_TOKEN` value (by creating api key from Terraform Cloud) at `self-manage` (mark sensitive)
- create organization manually
- provide `organization` variable set the organization
- change execution mode to Remote (but leave Manual apply for safety)
- Settings > Version Control > Version Control Workflow to connect this repo
- set `self-manage/cdktf.out/stacks/self-manage` to Terraform Working Directory

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
