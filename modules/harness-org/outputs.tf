output "org_id" {
  description = "The identifier of the created organization. Use this as org_id when creating projects."
  value       = harness_platform_organization.this.id
}

output "org_name" {
  description = "The display name of the organization."
  value       = harness_platform_organization.this.name
}
