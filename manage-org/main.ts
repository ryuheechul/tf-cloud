import { Construct } from "constructs";
import { App, TerraformStack, TerraformVariable, RemoteBackend } from "cdktf";
import { TfeProvider, TeamToken, DataTfeTeam } from "@cdktf/provider-tfe"

import { StandardWorkspace } from './lib/workspaces';

const hostname = 'app.terraform.io';

class MyStack extends TerraformStack {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    const organization = (new TerraformVariable(this, "organization", {
      description: "to be able to set Terraform Cloud Organization name via variable"
    })).value;

    new TfeProvider(this, "Tfe", {})

    // turns out this will not work on local execution as remote backend doesn't support reading variables
    // but it doesn't matter for now since this part is being igrnored on remote execution at TFC
    new RemoteBackend(this, {
      organization,
      hostname,
      workspaces: {
        name: "manage-org",
      },
    });

    const team = new DataTfeTeam(this, 'team_owners', {
      name: 'owners',
      organization
    })

    // in theory according to https://github.com/hashicorp/terraform-provider-fakewebservices#installation--usage,
    // team's token should be sufficent for fakewebservices but it may not work
    // in that case you might want to override manually
    const token = new TeamToken(this, 'team_token', {
      teamId: team.id
    })

    //TODO: enable `Include submodules on clone
    new StandardWorkspace(this, 'tfc-getting-started', {
      organization,
      workingDirectory: "tfc-getting-started",
      vars: [{
        name: 'provider_token',
        value: token.token,
        sensitive: true,
      }]
    });

    new StandardWorkspace(this, 'manage-org-tf', {
      organization,
      workingDirectory: "manage-org-tf",
    });

    const scopeForWS = this;

    ['dev', 'prod'].forEach((deploy) => {
      const name = "auto-tfvars";
      new StandardWorkspace(scopeForWS, name + '-' + deploy, {
        organization,
        workingDirectory: "auto-tfvars",
        vars: [{
          name: 'deploy_name',
          value: deploy,
          sensitive: false,
        }]
      });
    });
  }
}

const app = new App()
new MyStack(app, "manage-org");
app.synth();
