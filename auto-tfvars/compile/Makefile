.PHONY: deploy.auto.tfvars.json
deploy.auto.tfvars.json:
	cat dev.deploy.json
	cat prod.deploy.json
	jq -s '[.[0], .[1]]' dev.deploy.json prod.deploy.json | tee deploy.auto.tfvars.json | jq
