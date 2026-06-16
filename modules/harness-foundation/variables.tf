# ------------------------------------------------------------------------------
# Input validation — checks run at plan time before any API calls are made.
# ------------------------------------------------------------------------------

variable "create_org" {
  type        = bool
  description = "Set to true to create a new organization. Set to false to use an existing organization."
}

variable "existing_org_id" {
  type        = string
  default     = null
  description = "Identifier of an existing organization. Required when create_org is false."

  validation {
    condition = (
      var.existing_org_id == null ||
      can(regex("^[a-zA-Z_][0-9a-zA-Z_]*$", var.existing_org_id))
    )
    error_message = "existing_org_id must start with a letter or underscore and contain only letters, numbers, and underscores."
  }
}

variable "org" {
  type = object({
    identifier  = string
    name        = string
    description = optional(string)
    tags        = optional(set(string), [])
  })
  default     = null
  description = "Organization details. Required when create_org is true."
}

variable "projects" {
  type = map(object({
    name        = string
    description = optional(string)
    color       = optional(string, "#0063F7")
    tags        = optional(set(string), [])
  }))
  description = "Map of projects to create. Each map key becomes the project identifier."

  validation {
    condition     = length(var.projects) > 0
    error_message = "At least one project must be defined in the projects map."
  }

  validation {
    condition = alltrue([
      for id in keys(var.projects) : can(regex("^[a-zA-Z_][0-9a-zA-Z_]*$", id))
    ])
    error_message = "Every project identifier must start with a letter or underscore and contain only letters, numbers, and underscores."
  }
}

check "existing_org_required" {
  assert {
    condition     = var.create_org || (var.existing_org_id != null && var.existing_org_id != "")
    error_message = "existing_org_id must be set when create_org is false."
  }
}

check "org_details_required" {
  assert {
    condition     = !var.create_org || var.org != null
    error_message = "org must be set when create_org is true."
  }
}
