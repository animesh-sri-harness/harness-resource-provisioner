.PHONY: help init fmt fmt-check validate plan apply clean

TF_VAR_harness_endpoint         ?= https://harness.example.com/gateway
TF_VAR_harness_account_id       ?= example_account_id
TF_VAR_harness_platform_api_key ?= example_api_key

help:
	@echo "Targets:"
	@echo "  init        Initialize Terraform and download providers"
	@echo "  fmt         Format Terraform files"
	@echo "  fmt-check   Check Terraform formatting (CI-friendly)"
	@echo "  validate    Validate Terraform configuration"
	@echo "  plan        Run terraform plan"
	@echo "  apply       Run terraform apply"
	@echo "  clean       Remove local Terraform cache"

init:
	terraform init -backend=false

init-backend:
	terraform init

fmt:
	terraform fmt -recursive .

fmt-check:
	terraform fmt -check -recursive -diff .

validate: init
	terraform validate

plan: init
	terraform plan -input=false

apply: init
	terraform apply

clean:
	rm -rf .terraform
