import { Construct } from "constructs";
import { App, TerraformStack, TerraformVariable, RemoteBackend } from "cdktf";
import { TfeProvider, Workspace } from "@cdktf/provider-tfe"

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

    new Workspace(this, "tfc_getting_started", {
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
  }
}

const app = new App()
new MyStack(app, "self-manage");
app.synth();
