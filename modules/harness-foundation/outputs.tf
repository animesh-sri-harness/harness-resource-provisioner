output "org_id" {
  description = "Organization identifier all projects were created under."
  value       = local.org_id
}

output "org_created" {
  description = "True if a new organization was created in this run. False if an existing organization was used."
  value       = var.create_org
}

output "projects" {
  description = "Map of created projects keyed by identifier."
  value = {
    for key, project in module.projects : key => {
      project_id   = project.project_id
      project_name = project.project_name
      org_id       = project.org_id
      modules      = project.modules
    }
  }
}

output "project_ids" {
  description = "List of created project identifiers."
  value       = sort(keys(module.projects))
}
