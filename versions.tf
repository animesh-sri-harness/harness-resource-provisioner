# ------------------------------------------------------------------------------
# Terraform and provider version constraints
# ------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    harness = {
      source  = "harness/harness"
      version = "~> 0.43"
    }
  }

  # Remote state is required for production. See backend.hcl.example.
  #
  # backend "s3" {}
}
