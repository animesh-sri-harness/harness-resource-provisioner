# ------------------------------------------------------------------------------
# Harness foundation
#
# Provisions an optional organization and one or more projects.
#
# Configuration files (see README):
#   terraform.tfvars        — connection and organization settings
#   projects.auto.tfvars    — project list (edit to add or remove projects)
# ------------------------------------------------------------------------------

module "foundation" {
  source = "./modules/harness-foundation"

  create_org      = var.create_org
  existing_org_id = var.existing_org_id
  org             = var.org
  projects        = var.projects
}
