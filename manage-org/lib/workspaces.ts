import { Construct } from "constructs";
import { Workspace } from "@cdktf/provider-tfe";
import { setVar } from "./var";

interface TFVar {
  name: string,
  value: string,
  sensitive: boolean
}

interface StandardWorkspaceConfig {
  organization: string,
  workingDirectory: string,
  vars?: TFVar[]
}

export class StandardWorkspace extends Workspace {
  constructor(scope: Construct, name: string, config: StandardWorkspaceConfig) {
    const {
      organization,
      workingDirectory,
      vars,
    } = config;

    super(scope, name, {
      name,
      organization,
      executionMode: "remote",
      autoApply: true,
      workingDirectory,
      lifecycle: {
        ignoreChanges: ['vcs_repo'] // following actual provider's stanza
      }
      // // manage repo manually for now
      // vcsRepo: {
      //   identifier: "ryuheechul/tf-cloud",
      // }
    });

    const ws = { id: this.id };

    setVar(this, ws, 'tfc_organization', organization, false);
    // this is technically unnecessary because of `terraform.workspace` - https://www.terraform.io/language/expressions/references#filesystem-and-workspace-info
    // however `terraform.workspace` is hard to use in `cdktf` yet - https://github.com/hashicorp/terraform-cdk/issues/376
    setVar(this, ws, 'tfc_workspace', name, false);

    const scopeForVar = this;

    if (vars) {
      vars.forEach(({ name: n, value: v, sensitive }) => {
        setVar(scopeForVar, ws, n, v, sensitive);
      });
    }
  }
}
