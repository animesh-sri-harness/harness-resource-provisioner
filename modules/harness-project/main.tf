# ------------------------------------------------------------------------------
# Harness Project
#
# Creates a single Harness Project inside an organization.
# Projects are the primary scope for pipelines, connectors, secrets, and services.
# ------------------------------------------------------------------------------

resource "harness_platform_project" "this" {
  identifier  = var.identifier
  name        = var.name
  org_id      = var.org_id
  description = var.description
  color       = var.color
  tags        = length(var.tags) > 0 ? var.tags : null
}
