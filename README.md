# Harness Resource Provisioner

Terraform automation to create **Harness Organizations** (optional) and **Projects** on a **Self-Managed Harness Platform (SMP)**. Manage your Harness account structure as code — define organizations and projects in version-controlled configuration files and provision them with a standard Terraform workflow.

## What this repo does

| Resource | When created | Configured in |
|----------|--------------|---------------|
| Organization | Optional (`create_org = true`) | `terraform.tfvars` |
| Project(s) | Always (one or more) | `projects.auto.tfvars` |

## Repository structure

```
harness-resource-provisioner/
├── main.tf                        # Entry point
├── provider.tf                    # Harness provider configuration
├── variables.tf                   # Input variables and validations
├── outputs.tf                     # org_id and project identifiers
├── versions.tf                    # Terraform and provider versions
├── Makefile                       # Common Terraform commands
├── terraform.tfvars.example       # Connection and organization settings
├── projects.auto.tfvars.example   # Project list — edit to add projects
├── backend.hcl.example            # Remote state configuration
├── .github/workflows/terraform.yml
└── modules/
    ├── harness-org/               # Single organization resource
    ├── harness-project/           # Single project resource
    └── harness-foundation/        # Optional org + multiple projects
```

Configuration is split into two files:

| File | When to edit |
|------|--------------|
| `terraform.tfvars` | Connection and organization mode |
| `projects.auto.tfvars` | Add, update, or remove projects |

Terraform automatically loads `terraform.tfvars` and any `*.auto.tfvars` file.

---

## Prerequisites

1. **Terraform** `>= 1.5.0` — [Install Terraform](https://developer.hashicorp.com/terraform/install)
2. **Network access** to your Self-Managed Harness Platform API gateway
3. **Harness account ID** — Account Settings in the Harness UI
4. **Harness Platform API key** with permissions to:
   - Create organizations (only when `create_org = true`)
   - Create projects in the target organization

### API key permissions

Create an API key under **Account Settings → Access Control → API Keys** with a role that includes:

- `core_organization_edit` (when creating organizations)
- `core_project_edit`

Built-in roles such as `_account_admin` include these permissions. For production, prefer a **dedicated service account** with the minimum required permissions.

### Harness endpoint (Self-Managed)

```
https://<your-harness-host>/gateway
```

Example: `https://harness.company.com/gateway`

---

## Quick start

### Step 1: Clone the repository

```bash
git clone https://github.com/animesh-sri-harness/harness-resource-provisioner.git
cd harness-resource-provisioner
```

### Step 2: Create configuration files

```bash
cp terraform.tfvars.example terraform.tfvars
cp projects.auto.tfvars.example projects.auto.tfvars
```

Both files are gitignored.

### Step 3: Configure connection and organization

Edit `terraform.tfvars`:

- `harness_endpoint`
- `harness_account_id`
- `harness_platform_api_key`
- Organization mode (see [Organization configuration](#organization-configuration))

**Recommended for production CI/CD** — store secrets in environment variables instead of files:

```bash
export HARNESS_ENDPOINT="https://harness.example.com/gateway"
export HARNESS_ACCOUNT_ID="your_account_id"
export HARNESS_PLATFORM_API_KEY="your_platform_api_key"
```

When environment variables are set, omit the credential fields from `terraform.tfvars` and keep only non-secret settings such as `harness_endpoint` and organization configuration.

### Step 4: Define projects

Edit `projects.auto.tfvars`. The **map key becomes the project identifier**:

```hcl
projects = {
  platform_dev = {
    name        = "Platform Dev"
    description = "Development environment"
    tags        = ["env:dev", "team:platform"]
  }
}
```

### Step 5: Initialize, plan, and apply

```bash
make init
make plan
make apply
```

Or without Make:

```bash
terraform init
terraform plan
terraform apply
```

### Step 6: Capture outputs

```bash
terraform output
```

Record `org_id` and `project_ids` from the output for reference in your Harness workflows.

---

## Adding a new project

1. Open `projects.auto.tfvars`
2. Add an entry to the `projects` map:

```hcl
projects = {
  # ... existing projects ...

  payments_service = {
    name        = "Payments Service"
    description = "Payments team delivery project"
    tags        = ["team:payments", "env:prod"]
  }
}
```

3. Apply:

```bash
terraform plan
terraform apply
```

Only the new project is created. Existing projects are unchanged.

**Removing a project** deletes it from Harness and destroys all resources inside it. Review `terraform plan` carefully before applying destructive changes in production.

---

## Organization configuration

Choose one mode in `terraform.tfvars`.

### Mode A — Existing organization (recommended)

```hcl
create_org      = false
existing_org_id = "default"
```

### Mode B — New organization

```hcl
create_org = true

org = {
  identifier  = "platform_engineering"
  name        = "Platform Engineering"
  description = "Shared platform organization"
  tags        = ["team:platform"]
}
```

---

## Project field reference

| Field | Required | Description |
|-------|----------|-------------|
| Map key | Yes | Project identifier (unique within the org; letters, numbers, underscores) |
| `name` | Yes | Display name in the Harness UI |
| `description` | No | Short description |
| `color` | No | Hex color (default: `#0063F7`) |
| `tags` | No | Tags in `key:value` format |

---

## Production checklist

Before using this in a production Harness account:

- [ ] Configure **remote state** (see below) — do not rely on local state files
- [ ] Use a **dedicated API key** with least-privilege permissions
- [ ] Store `HARNESS_ACCOUNT_ID` and `HARNESS_PLATFORM_API_KEY` in your CI/CD secret manager, not in git
- [ ] Use a **separate state file per environment** (different `key` in `backend.hcl`)
- [ ] Require `terraform plan` review before every `apply`
- [ ] Restrict who can run `terraform destroy` on production state backends
- [ ] Run `make fmt-check validate` locally or rely on the GitHub Actions workflow before merging

---

## Remote state

Local state is suitable for initial testing only. Production deployments should use remote state with locking.

1. Copy `backend.hcl.example` to `backend.hcl` (gitignored)
2. Uncomment `backend "s3" {}` in `versions.tf`
3. Initialize:

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

Use a different `key` per environment, for example:

- `harness-resource-provisioner/dev/terraform.tfstate`
- `harness-resource-provisioner/prod/terraform.tfstate`

---

## Importing existing resources

To adopt resources created manually in the Harness UI:

```bash
# Organization (only when create_org = true)
terraform import 'module.foundation.module.org[0].harness_platform_organization.this' <org_identifier>

# Project
terraform import 'module.foundation.module.projects["my_project_id"].harness_platform_project.this' <org_id>/<project_id>
```

Add the matching entry to `projects.auto.tfvars`, then run `terraform plan` to verify zero drift.

---

## Development

```bash
make fmt-check    # Check formatting
make validate     # Validate configuration
```

Use `make init-backend` when configuring a remote state backend (after uncommenting `backend "s3" {}` in `versions.tf`).

A GitHub Actions workflow runs format check and validation on every pull request.

---

## Troubleshooting

| Issue | Likely cause | What to do |
|-------|--------------|------------|
| `401 Unauthorized` | Invalid API key or endpoint | Verify endpoint, account ID, and API key |
| `403 Access Denied` | Insufficient API key permissions | Grant `core_organization_edit` / `core_project_edit` |
| `Organization not found` | Wrong `existing_org_id` | Use the org identifier from the UI, not the display name |
| `Duplicate identifier` | Resource already exists | Import the resource or use a different identifier |
| Plan validation error | Missing or invalid variables | Check `existing_org_id` / `org` and project identifier format |
| Projects not loaded | Missing variable file | Run `cp projects.auto.tfvars.example projects.auto.tfvars` |

---

## References

- [Harness Terraform Provider](https://registry.terraform.io/providers/harness/harness/latest/docs)
- [Harness Terraform Provider Quickstart](https://developer.harness.io/docs/platform/automation/terraform/harness-terraform-provider/)
- [Self-Managed Enterprise Edition docs](https://developer.harness.io/docs/self-managed-enterprise-edition/)
- [`harness_platform_organization`](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_organization)
- [`harness_platform_project`](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_project)
