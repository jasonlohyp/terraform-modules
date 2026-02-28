# Terraform Modules

A collection of reusable Terraform modules for Google Cloud Platform (GCP). Built to eliminate infrastructure duplication across projects — define once, reuse everywhere.

> Inspired by platform engineering principles from central GCP governance work. Any project can consume these modules without repeating infrastructure code.

---

## Available Modules

| Module | Description | Status |
|---|---|---|
| [cloud-run](./cloud-run/) | Deploy containerised apps to Google Cloud Run | ✅ Available |

---

## How to Use

Each module is consumed by referencing this repo as a Terraform source. Example:

```hcl
module "cloud_run" {
  source = "github.com/jasonlohyp/terraform-modules/cloud-run"

  project_id      = "my-gcp-project"
  app_name        = "my-app"
  container_image = "gcr.io/my-project/my-app:latest"
  region          = "europe-west1"

  env_vars = {
    ENV = "production"
  }

  secret_env_vars = {
    API_KEY = "MY_SECRET_NAME"
  }
}

output "app_url" {
  value = module.cloud_run.service_url
}
```

No need to copy infrastructure code between projects. Just call the module with your specific values.

---

## Design Principles

- **Simple by default**: Every module works out of the box with minimal configuration. Sensible defaults mean you only override what you need.

- **Configurable for production**: Optional variables unlock enterprise features like private ingress, authentication, and higher resource limits when needed.

- **Cost conscious**: Defaults are optimised for low-cost personal and portfolio projects (scale to zero, single instance). Production settings are opt-in.

- **Secure**: Sensitive values like API keys are passed as variables, never hardcoded. Modules support environment variable injection and are compatible with Google Secret Manager.

---

## Repo Structure

```
terraform-modules/
└── cloud-run/          ← Google Cloud Run module
    ├── main.tf         ← Resource definitions
    ├── variables.tf    ← Input variables
    ├── outputs.tf      ← Output values
    └── README.md       ← Module documentation
```

---

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (for authentication)
- A GCP project with billing enabled

### Authentication
```bash
gcloud auth application-default login
```

---

## Roadmap

- [x] Cloud Run module
- [ ] Cloud Storage bucket module
- [ ] Artifact Registry module
- [ ] Cloud SQL module
- [ ] GitHub Actions CI/CD pipeline for auto-deployment

---

## Projects Using These Modules

| Project | Module Used | Description |
|---|---|---|
| [swedish-tutor-agent](https://github.com/jasonlohyp/swedish-tutor-agent) | cloud-run | AI-powered Swedish language tutor |

