import { Construct } from "constructs";
import { TerraformVariable } from "cdktf";
import { Variable } from "@cdktf/provider-tfe"

interface Var {
  key: string,
  value: string,
}

interface VarType {
  sensitive?: boolean
  category: string,
}

// helper consts
export const envVar = { category: 'env' };
export const tfVar = { category: 'terraform' };

export interface RichVar extends Var, VarType { }

interface SetAndForgetVariableConfig extends RichVar {
  workspaceId: string,
}

export class SetAndForgetVariable extends Variable {
  constructor(scope: Construct, config: SetAndForgetVariableConfig) {
    // if callthing this for same name twice in the same scope, the key name will collide
    // initially the key name was dirty like this, `'tfvar-' + key + 'FOR' + workspace.name`
    // to allow that behavior but it's just better to call this per workspace scope
    // just like how it's done at ./workspaces.ts

    super(scope, config.key, {
      ...config,
      // this will be taken care of by `addOverride` instead - https://github.com/hashicorp/terraform-cdk/issues/1425#issuecomment-995601755
      // lifecycle: { ignoreChanges: 'all' },
    });

    // this means it will not track the changes after creation
    // however, applying new change is still possible when the var is deleted (so delete if you need to update the value by this code
    this.addOverride('lifecycle.ignore_changes', 'all');
  }
}

export function fetchVar(scope: Construct, name: string, description = "") {
  return (new TerraformVariable(scope, name, {
    description,
  })).value;
}
