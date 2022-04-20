# Terraform Cloud Integration With Github

_Things written here is based on my intepretation of what I experienced on the time of writing so it might not be true or applicable any more when you read it._

A bit lengthy but general guide can be found at https://www.hashicorp.com/resources/a-practitioner-s-guide-to-using-hashicorp-terraform-cloud-with-github

And here are two distinctive approaches I went through.

## 1. Configuration-Free GitHub Usage

Which corresponds to this doc, https://www.terraform.io/cloud-docs/vcs/github-app

This is basically a quick and dirty way to integrate with Github. Click through some steps and voila! Now you allowed your Terraform Cloud Organization/Workspace to access certain repos on Github.

It works well if you a managing TFC mainly via web console (GUI).

## 2. Configure GitHub.com Access through OAuth
Which corresponds to this doc, https://learn.hashicorp.com/tutorials/terraform/github-oauth

This is another way to integrate with Github. It involes with a bit more than just clicking buttons but it's actually not that much.

And this method is "necessary" if you are managing workspaces via [tfe provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace#vcs_repo)

_Otherwise you should be able to [do even this with code](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) but I personally wouldn't do this unless it's absolutely required._

Since the guide above is a tutorial, it misses some details and those missing details can be found at https://www.terraform.io/cloud-docs/vcs/github in case you want to know more about how things work.
## Things to Note

### Two Different Github Apps
Unless you are super familiar with all different way to handle integrations with Github, somethings might confuse you.

For example the way 1. is using [Github App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps)
which will show up at `https://github.com/settings/installations` or `https://github.com/organizations/[your-org]/settings/apps`.
The name will be "Terraform Cloud". And also [harshicorp](https://github.com/hashicorp) themselves are the developer of this particular app and you are just using it.

Whereas way 2. is using [Github OAuth App](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)
which will be listed at `https://github.com/settings/developers` or `https://github.com/organizations/[your-org]/settings/applications`.
And this app is actually created and named by you (or your org) specifically for your needs.

This confusion must be quite common that they even mentions it in [their tutorial](https://learn.hashicorp.com/tutorials/terraform/github-oauth)

> In the navigation sidebar, click "Developer settings," then make sure you're on the "OAuth Apps" page (not "GitHub Apps").

### Ownership of the Oauth App
If you happend to create an oauth app under your individual account (which is very easy to fall on this path if you followed the tutorial "mindlessly" like me) but that is actually for your particular organization, you should [transfer the ownership](https://docs.github.com/en/developers/apps/managing-oauth-apps/transferring-ownership-of-an-oauth-app) to the org in order to make things right and avoid confusion for a time when you are no longer in the org.

### You Might Be a Proxy

Since the (Github's) bot account concept is nowhere to be found [here](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts), it's likely you (or someone else) is the entity that exist in between Terraform Cloud and Github when you are at [this stage](https://learn.hashicorp.com/tutorials/terraform/github-oauth#on-terraform-cloud-set-up-your-provider).

This means your org is dependant on that particular individual account for this integration and it will be fine (in org' point of view, maybe you would think differently) until that account is no longer in the org.

You might start seeing that pulling repositories from Github might stop working at that point.

But the remediation is relatively simple. Either before or after that event, simply revoke the user from `https://github.com/organizations/[your-org]/settings/applications/[app-number]` like below

![image borrowed from TFC](https://mktg-content-api-hashicorp.vercel.app/api/assets?product=tutorials&version=main&asset=public%2Fimg%2Fterraform%2Fkubernetes%2Fgithub-oauth-app-client-id-secret.png)

And follow [this step again](https://learn.hashicorp.com/tutorials/terraform/github-oauth#on-terraform-cloud-set-up-your-provider) to connect someone else (probably you if you are reading this) within your org that has sufficient access.

Hope the reality is not much different from what I described above and this is at least the gist of remidiation.

### Both Apps Can Coexist

After you "switching" to using OAuth way from the "configuration free" way, you might wonder something like 'do I still need "Terraform Cloud" Github app?'.

I would say yes, if at least one workspace (probably one that manages TFC itself) is configured manually via the "configuration free" way, it would be more resilient to be not related with OAuth configuration.
Just in case you still want this special workspace to be still working when the OAuth configuration gets interrupted by whatever reason.

But this comes with a cost of having a confusion in the VCS settings in TFC.
Because they could both appear as just "Github" on both an input page as well as viewing page about VCS settings per workspace.

So I would name the OAuth app (at `https://app.terraform.io/app/[your-org]/settings/version-control`) to something like `Github via OAuth` to be clear about which method your repo is connect to a workspace.
