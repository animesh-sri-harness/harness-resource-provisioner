output "project_id" {
  description = "The identifier of the created project."
  value       = harness_platform_project.this.id
}

output "org_id" {
  description = "The parent organization identifier."
  value       = harness_platform_project.this.org_id
}

output "project_name" {
  description = "The display name of the project."
  value       = harness_platform_project.this.name
}

output "modules" {
  description = "Harness modules enabled on this project (read-only from the API)."
  value       = harness_platform_project.this.modules
}
