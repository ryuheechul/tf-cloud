#!/usr/bin/env bash

set -e

# This script is dependent on https://github.com/hashicorp-community/tf-helper#installation
# It is to inject necessary variables (including secrets)
# Make sure you provide right variables to overwrite
# Since this script updates all the variables at once (for specific workspace), it might not be suitable to update just one variable (you might be better off with web console to do it)

# make sure that these match with actual organization and workspace at app.terraform.io
# export TFH_org=my-org-name
# export TFH_name=manage-org

org="${TFH_org}"
ws="${TFH_name}"

# fail fast in case these are missing

fail-on-missing() {
	if test -z "${!1}"; then
		echo '$'"$1"' is missing'
		exit 1
	else
		true
	fi
}

fail-on-missing TFH_org
fail-on-missing TFH_name
fail-on-missing TFC_OAUTH_CLIENT_ID

push-var() {
	tfh pushvars -overwrite ${1} -var ${1}="${2}"
}

push-evar() {
	tfh pushvars -overwrite ${1} -env-var ${1}="${2}"
}

push-svar() {
	tfh pushvars -overwrite ${1} -svar ${1}="${2}"
}

push-sevar() {
	tfh pushvars -overwrite ${1} -senv-var ${1}="${2}"
}

pull-var() {
	tfh pullvars -var ${1}
}

pull-evar() {
	tfh pullvars -env-var ${1}
}

echo "going to push (overwrite) these values"

push-var organization "${org}"
push-var workspace "${ws}"
push-var main_repo "$(git remote get-url origin | sed 's/git@.*://' | sed 's/.git$//')"
push-svar tfc_oauth_client_id "${TFC_OAUTH_CLIENT_ID}"

push-sevar SECRET_ENV_VAR_EXAMPLE "very secret"

echo "verifying the values pushed"

pull-var organization
pull-var workspace
pull-var main_repo
pull-var tfc_oauth_client_id

# since we can't retrieve the content of sensitive value, retrieving empty value means the value exists
pull-evar SECRET_ENV_VAR_EXAMPLE
