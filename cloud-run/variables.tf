variable "project_id" {
  description = "The GCP project ID where the Cloud Run service will be deployed."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy the Cloud Run service in."
  type        = string
  default     = "europe-west1"
}

variable "app_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "container_image" {
  description = "The full URL of the container image to deploy."
  type        = string
}

variable "env_vars" {
  description = "A map of environment variables to pass to the container."
  type        = map(string)
  default     = {}
}

variable "max_instances" {
  description = "The maximum number of instances for the Cloud Run service."
  type        = number
  default     = 1
}

variable "min_instances" {
  description = "The minimum number of instances for the Cloud Run service (0 = scale to zero)."
  type        = number
  default     = 0
}

variable "memory" {
  description = "The amount of memory to allocate to the container (e.g., '512Mi')."
  type        = string
  default     = "512Mi"
}

variable "cpu" {
  description = "The number of CPUs to allocate to the container (e.g., '1')."
  type        = string
  default     = "1"
}

variable "concurrency" {
  description = "The maximum number of concurrent requests per instance."
  type        = number
  default     = 10
}

variable "timeout_seconds" {
  description = "The request timeout in seconds."
  type        = number
  default     = 60
}

variable "allow_public_access" {
  description = "Whether to allow unauthenticated public access to the service."
  type        = bool
  default     = true
}

variable "ingress" {
  description = "The ingress settings for the Cloud Run service. Valid values: INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "enable_iap" {
  description = "Whether to enable Identity-Aware Proxy (IAP) for the service (placeholder for future implementation)."
  type        = bool
  default     = false
}

variable "secret_env_vars" {
  description = "Map of environment variable names to Secret Manager secret IDs. These are mounted securely from GCP Secret Manager."
  type        = map(string)
  default     = {}
}
