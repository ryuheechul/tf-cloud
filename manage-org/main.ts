import { Construct } from "constructs";
import { App, TerraformStack, TerraformVariable, RemoteBackend } from "cdktf";
import { TfeProvider, Workspace, Variable, TeamToken, DataTfeTeam } from "@cdktf/provider-tfe"

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

    createWorkspaceTfcGettingStarted(this, organization, token.token)
  }
}

const app = new App()
new MyStack(app, "manage-org");
app.synth();

function createWorkspaceTfcGettingStarted(scope: Construct, organization: string, token: string) {
  const workspace = new Workspace(scope, "tfc_getting_started", {
    name: "tfc-getting-started",
    organization,
    executionMode: "remote",
    autoApply: true,
    workingDirectory: "tfc-getting-started",
    lifecycle: {
      ignoreChanges: ['vcs_repo'] // following actual provider's stanza
    }
    // // manage repo manually (given with nice UI from Terraform Cloud web page) might be practically a lot better until the scale is too big
    // vcsRepo: {}
  })

  const key = 'provider_token';
  const tokenVar = new Variable(scope, key, {
    key,
    sensitive: true,
    workspaceId: workspace.id,
    category: 'terraform',
    value: token,
    // this will be taken care of by `addOverride` instead - https://github.com/hashicorp/terraform-cdk/issues/1425#issuecomment-995601755
    // lifecycle: { ignoreChanges: 'all' },
  })

  tokenVar.addOverride('lifecycle.ignore_changes', 'all');
}
