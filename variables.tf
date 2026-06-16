# ==============================================================================
# Harness connection
#
# Set in terraform.tfvars or via environment variables (recommended for CI/CD):
#   HARNESS_ENDPOINT
#   HARNESS_ACCOUNT_ID
#   HARNESS_PLATFORM_API_KEY
# ==============================================================================

variable "harness_endpoint" {
  type        = string
  description = "Harness API gateway URL. Example: https://harness.example.com/gateway"

  validation {
    condition     = can(regex("^https?://", var.harness_endpoint))
    error_message = "harness_endpoint must be a valid HTTP or HTTPS URL."
  }
}

variable "harness_account_id" {
  type        = string
  description = "Harness account identifier from Account Settings."
  sensitive   = true
  nullable    = true
  default     = null
}

variable "harness_platform_api_key" {
  type        = string
  description = "Harness Platform API key with organization and project permissions."
  sensitive   = true
  nullable    = true
  default     = null
}

# ==============================================================================
# Organization settings (terraform.tfvars)
#
# Mode A — existing organization:
#   create_org      = false
#   existing_org_id = "your_org_id"
#
# Mode B — new organization:
#   create_org = true
#   org        = { identifier = "...", name = "...", ... }
# ==============================================================================

variable "create_org" {
  type        = bool
  description = "Set to true to create a new organization. Set to false to use an existing organization."
}

variable "existing_org_id" {
  type        = string
  default     = null
  description = "Identifier of an existing organization. Required when create_org is false."
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

# ==============================================================================
# Projects (projects.auto.tfvars)
# ==============================================================================

variable "projects" {
  type = map(object({
    name        = string
    description = optional(string)
    color       = optional(string, "#0063F7")
    tags        = optional(set(string), [])
  }))
  description = "Map of projects to create. Each map key becomes the project identifier."
}
