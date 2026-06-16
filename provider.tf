# ------------------------------------------------------------------------------
# Harness provider (Self-Managed Platform)
#
# Credentials can be supplied via terraform.tfvars or environment variables.
# For production CI/CD pipelines, prefer environment variables for secrets.
# ------------------------------------------------------------------------------

provider "harness" {
  endpoint         = var.harness_endpoint
  account_id       = var.harness_account_id
  platform_api_key = var.harness_platform_api_key
}
