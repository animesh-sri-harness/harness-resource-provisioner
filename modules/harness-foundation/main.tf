# ------------------------------------------------------------------------------
# Harness Foundation
#
# Orchestrates optional organization creation and one-or-more project creation.
#
# Modes (controlled by create_org):
#   create_org = true  -> create a new org, then create projects under it
#   create_org = false -> look up an existing org, then create projects under it
# ------------------------------------------------------------------------------

module "org" {
  source = "../harness-org"
  count  = var.create_org ? 1 : 0

  identifier  = var.org.identifier
  name        = var.org.name
  description = try(var.org.description, null)
  tags        = try(var.org.tags, [])
}

data "harness_platform_organization" "existing" {
  count      = var.create_org ? 0 : 1
  identifier = var.existing_org_id
}

locals {
  org_id = var.create_org ? module.org[0].org_id : data.harness_platform_organization.existing[0].id
}

module "projects" {
  source   = "../harness-project"
  for_each = var.projects

  org_id      = local.org_id
  identifier  = each.key
  name        = each.value.name
  description = try(each.value.description, null)
  color       = try(each.value.color, "#0063F7")
  tags        = try(each.value.tags, [])
}
