import { Construct } from "constructs";
import { TerraformVariable } from "cdktf";
import { Variable } from "@cdktf/provider-tfe"

export function fetchVar(scope: Construct, name: string, description = "") {
  return (new TerraformVariable(scope, name, {
    description,
  })).value;
}

export function setVar(scope: Construct, workspace: { id: string }, key: string, value: string, sensitive = true) {
  // if callthing this for same name twice in the same scope, the key name will collide
  // initially the key name was dirty like this, `'tfvar-' + key + 'FOR' + workspace.name`
  // to allow that behavior but it's just better to call this per workspace scope
  // just like how it's done at ./workspaces.ts
  (new Variable(scope, 'tfvar-' + key, {
    key,
    sensitive,
    workspaceId: workspace.id,
    category: 'terraform',
    value,
    // this will be taken care of by `addOverride` instead - https://github.com/hashicorp/terraform-cdk/issues/1425#issuecomment-995601755
    // lifecycle: { ignoreChanges: 'all' },
  }))
    // this means it will not track the changes after creation
    // however, applying new change is still possible when the var is deleted (so delete if you need to update the value by this code
    .addOverride('lifecycle.ignore_changes', 'all');
}

export function setEnvVar(scope: Construct, workspace: { id: string }, key: string, value: string, sensitive = true) {
  (new Variable(scope, 'envvar-' + key, {
    key,
    sensitive,
    workspaceId: workspace.id,
    category: 'env',
    value,
    // this will be taken care of by `addOverride` instead - https://github.com/hashicorp/terraform-cdk/issues/1425#issuecomment-995601755
    // lifecycle: { ignoreChanges: 'all' },
  }))
    // this means it will not track the changes after creation
    // however, applying new change is still possible when the var is deleted (so delete if you need to update the value by this code
    .addOverride('lifecycle.ignore_changes', 'all');
}
