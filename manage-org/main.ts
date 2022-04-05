import { Construct } from "constructs";
import { App, TerraformStack, TerraformVariable, RemoteBackend } from "cdktf";
import { TfeProvider, TeamToken, DataTfeTeam } from "@cdktf/provider-tfe"

import { StandardWorkspace } from './lib/workspaces';
import { tfVar, envVar } from './lib/var';

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

    // Adding workspaces, this should be comparable to ../manage-org-tf/main.tf

    //TODO: enable `Include submodules on clone` option
    new StandardWorkspace(this, 'tfc-getting-started', {
      organization,
      workingDirectory: "tfc-getting-started",
      vars: [
        {
          ...tfVar,
          sensitive: true,
          key: 'provider_token',
          value: token.token,
        }
      ]
    });

    new StandardWorkspace(this, 'manage-org-tf', {
      organization,
      workingDirectory: "manage-org-tf",
      structuredRunOutputEnabled: false,
      vars: [
        {
          ...envVar,
          sensitive: true,
          key: 'TFE_TOKEN',
          value: token.token,
        },
        // adding and removing this might be better off doing it manually if the switching will be frequent
        // also this might require to turn this to `false`, https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace#structured_run_output_enabled
        {
          ...envVar,
          key: 'TF_LOG',
          value: 'trace'
        }
      ]
    });

    const scopeForWS = this;

    ['dev', 'prod'].forEach((deploy) => {
      const name = "auto-tfvars";
      new StandardWorkspace(scopeForWS, name + '-' + deploy, {
        organization,
        workingDirectory: "auto-tfvars",
        vars: [{
          ...tfVar,
          key: 'deploy_name',
          value: deploy,
        }]
      });
    });

    //TODO: add outputs that is similar to ../manage-org-tf/outputs.tf
  }
}

const app = new App()
new MyStack(app, "manage-org");
app.synth();
