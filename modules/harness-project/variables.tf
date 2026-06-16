variable "org_id" {
  type        = string
  description = "Identifier of the parent organization."

  validation {
    condition     = can(regex("^[a-zA-Z_][0-9a-zA-Z_]*$", var.org_id))
    error_message = "Organization identifier must start with a letter or underscore and contain only letters, numbers, and underscores."
  }
}

variable "identifier" {
  type        = string
  description = "Unique identifier for the project within the organization."

  validation {
    condition     = can(regex("^[a-zA-Z_][0-9a-zA-Z_]*$", var.identifier))
    error_message = "Project identifier must start with a letter or underscore and contain only letters, numbers, and underscores."
  }
}

variable "name" {
  type        = string
  description = "Display name shown in the Harness UI."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "Project name must not be empty."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Optional description for the project."
}

variable "color" {
  type        = string
  default     = "#0063F7"
  description = "Hex color code for the project icon in the Harness UI."

  validation {
    condition     = can(regex("^#[0-9A-Fa-f]{6}$", var.color))
    error_message = "Project color must be a valid hex color code, for example #0063F7."
  }
}

variable "tags" {
  type        = set(string)
  default     = []
  description = "Optional tags in key:value format, for example [\"team:platform\", \"env:prod\"]."
}
