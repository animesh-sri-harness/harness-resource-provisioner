output "org_id" {
  description = "Organization identifier where projects were created."
  value       = module.foundation.org_id
}

output "org_created" {
  description = "True if a new organization was created in this run."
  value       = module.foundation.org_created
}

output "project_ids" {
  description = "Sorted list of created project identifiers."
  value       = module.foundation.project_ids
}

output "projects" {
  description = "Map of created projects with identifiers and metadata."
  value       = module.foundation.projects
}
