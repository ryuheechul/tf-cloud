import { Construct } from "constructs";
import { Workspace, WorkspaceVcsRepo } from "@cdktf/provider-tfe";
import { SetAndForgetVariable, RichVar, tfVar } from "./var";

interface StandardWorkspaceConfig {
  organization: string,
  workingDirectory: string,
  structuredRunOutputEnabled?: boolean,
  vcsRepo: WorkspaceVcsRepo,
  vars?: RichVar[],
}

export class StandardWorkspace extends Workspace {
  constructor(scope: Construct, name: string, config: StandardWorkspaceConfig) {
    const {
      organization,
      workingDirectory,
      structuredRunOutputEnabled,
      vcsRepo,
      vars,
    } = config;

    super(scope, name, {
      name,
      organization,
      executionMode: "remote",
      autoApply: true,
      workingDirectory,
      structuredRunOutputEnabled,
      vcsRepo,
    });

    const self = this;

    const defaultVars = [
      {
        ...tfVar,
        key: 'tfc_organization',
        value: organization,
      },
      // this is technically unnecessary because of `terraform.workspace` - https://www.terraform.io/language/expressions/references#filesystem-and-workspace-info
      // however `terraform.workspace` is hard to use in `cdktf` yet - https://github.com/hashicorp/terraform-cdk/issues/376
      {
        ...tfVar,
        key: 'tfc_workspace',
        value: name,
      },
    ];

    const varsOrEmpty = vars ? vars : [];

    [...defaultVars, ...varsOrEmpty]
      .map(config => ({
        workspaceId: self.id,
        ...config,
      }))
      .forEach((config) => {
        new SetAndForgetVariable(self, config)
      });
  }
}
