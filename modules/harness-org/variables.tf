variable "identifier" {
  type        = string
  description = "Unique identifier for the organization."

  validation {
    condition     = can(regex("^[a-zA-Z_][0-9a-zA-Z_]*$", var.identifier))
    error_message = "Organization identifier must start with a letter or underscore and contain only letters, numbers, and underscores."
  }
}

variable "name" {
  type        = string
  description = "Display name shown in the Harness UI."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "Organization name must not be empty."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Optional description for the organization."
}

variable "tags" {
  type        = set(string)
  default     = []
  description = "Optional tags in key:value format, for example [\"team:platform\", \"env:prod\"]."
}
