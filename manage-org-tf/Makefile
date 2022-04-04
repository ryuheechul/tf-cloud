.PHONY: test
test: init fmt validate

.PHONY: init
init:
	terraform init

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: validate
validate:
	terraform validate

.PHONY: plan
plan:
	terraform plan
