# Enable required APIs
resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

# Cloud Run V2 Service
resource "google_cloud_run_v2_service" "default" {
  name     = var.app_name
  location = var.region
  project  = var.project_id
  ingress  = var.ingress

  template {
    scaling {
      max_instance_count = var.max_instances
      min_instance_count = var.min_instances
    }

    containers {
      image = var.container_image

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    max_instance_request_concurrency = var.concurrency
    timeout                          = "${var.timeout_seconds}s"
  }

  # Ensure APIs are enabled before creating the service
  depends_on = [
    google_project_service.run_api,
    google_project_service.artifact_registry_api
  ]
}

# Public access (Conditional)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  count    = var.allow_public_access ? 1 : 0
  location = google_cloud_run_v2_service.default.location
  project  = google_cloud_run_v2_service.default.project
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
