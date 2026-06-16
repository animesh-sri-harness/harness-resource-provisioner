# ------------------------------------------------------------------------------
# Harness Organization
#
# Creates a single Harness Organization at the account level.
# Invoked by harness-foundation when create_org = true.
# ------------------------------------------------------------------------------

resource "harness_platform_organization" "this" {
  identifier  = var.identifier
  name        = var.name
  description = var.description
  tags        = length(var.tags) > 0 ? var.tags : null
}
