import { Construct } from "constructs";
import { App, TerraformStack, TerraformVariable, RemoteBackend } from "cdktf";
import { TfeProvider, Workspace, Variable, OrganizationToken } from "@cdktf/provider-tfe"

const hostname = "app.terraform.io";

class MyStack extends TerraformStack {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    const organization = (new TerraformVariable(this, "organization", {
      description: "to be able to set Terraform Cloud Organization name via variable"
    })).value;

    new TfeProvider(this, "Tfe", {
      hostname,
    })

    new RemoteBackend(this, {
      organization,
      hostname,
      workspaces: {
        name: "self-manage",
      },
    });

    const token = new OrganizationToken(this, 'org_token', {
      organization
    })

    createWorkspaceTfcGettingStarted(this, organization, token.token)
  }
}

const app = new App()
new MyStack(app, "self-manage");
app.synth();

function createWorkspaceTfcGettingStarted(scope: Construct, organization: string, token: string) {
  const workspace = new Workspace(scope, "tfc_getting_started", {
    name: "tfc-getting-started",
    organization,
    executionMode: "remote",
    autoApply: true,
    workingDirectory: "tfc_getting_started",
    lifecycle: {
      ignoreChanges: ['vcs_repo'] // following actual provider's stanza
    }
    // // manage repo manually (given with nice UI from Terraform Cloud web page) might be practically a lot better until the scale is too big
    // vcsRepo: {}
  })

  createVariable(scope, workspace.id, 'provider_token', token, true);
}

function createVariable(scope: Construct, workspace: string, key: string, value: string, sensitive = false) {
  new Variable(scope, key, {
    category: 'terraform',
    sensitive,
    value,
    key,
    workspaceId: workspace
  })
}
