# Google Cloud Run Terraform Module

## Overview
A reusable Terraform module for deploying containerized applications to **Google Cloud Run (V2)**. This module is designed to be **simple by default** for rapid prototyping and portfolio projects, yet **highly configurable** for production-grade enterprise deployments.

---

## Default Setup (Simple & Free)
By default, this module is optimized for the **GCP Free Tier** and low-traffic projects.

- **Direct Public Access**: No complex Load Balancer required (Service URL provided).
- **Unauthenticated**: No authentication required by default (`allow_public_access = true`).
- **Scale to Zero**: `min_instances = 0` ensures you pay nothing when the service is idle.
- **Cost Protection**: `max_instances = 1` prevents unexpected billing spikes.
- **Estimated Cost**: **$0/month** for low-traffic portfolio projects.

### Simple Architecture
```text
Internet  ──▶  Cloud Run Service (HTTPS)
```

---

## Production Setup (Optional)
For enterprise-grade applications, this module supports hardened security patterns.

- **Restricted Ingress**: Set `ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"`.
- **Load Balancing**: Place a Global HTTP(S) Load Balancer in front of the service.
- **WAF Protection**: Enable **Cloud Armor** on the Load Balancer for DDoS and SQLi protection.
- **Enterprise Auth**: Enable **Identity-Aware Proxy (IAP)** for internal employee access.
- **Estimated Cost**: **~$20-25/month** (base cost for Load Balancer + Cloud Armor).

### Production Architecture
```text
Internet  ──▶  Cloud Load Balancer  ──▶  Cloud Armor  ──▶  Cloud Run
                                          (WAF)
```

---

## Usage Example
Minimal example for a simple portfolio application:

```hcl
module "portfolio_app" {
  source = "./cloud-run"

  project_id      = "my-gcp-project"
  app_name        = "my-portfolio"
  container_image = "gcr.io/my-project/portfolio-ui:latest"
  
  # Scaling optimized for free tier
  max_instances = 1
  min_instances = 0
}
```

---

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The GCP project ID for deployment. | `string` | n/a | **Yes** |
| `region` | GCP region for deployment. | `string` | `"europe-west1"` | No |
| `app_name` | Name of the Cloud Run service. | `string` | n/a | **Yes** |
| `container_image` | Full container image URL. | `string` | n/a | **Yes** |
| `env_vars` | Map of environment variables. | `map(string)` | `{}` | No |
| `max_instances` | Max instances for scaling. | `number` | `1` | No |
| `min_instances` | Min instances (0 = scale to zero). | `number` | `0` | No |
| `memory` | Container memory (e.g., "512Mi"). | `string` | `"512Mi"` | No |
| `cpu` | Container CPU (e.g., "1"). | `string` | `"1"` | No |
| `concurrency` | Max concurrent requests per instance. | `number` | `10` | No |
| `timeout_seconds` | Request timeout in seconds. | `number` | `60` | No |
| `allow_public_access` | Enable unauthenticated access. | `bool` | `true` | No |
| `ingress` | Ingress settings (ALL/INTERNAL/LB). | `string` | `"INGRESS_TRAFFIC_ALL"` | No |
| `enable_iap` | Placeholder to enable IAP support. | `bool` | `false` | No |

---

## Outputs

| Name | Description |
|------|-------------|
| `service_url` | The live public URL of the deployed Cloud Run service. |
| `service_name` | The name of the Cloud Run service. |

---

## Security Considerations

| Feature | Direct Public Access | Load Balancer + Cloud Armor |
|---------|-----------------------|-----------------------------|
| **Cost** | Free ($0/mo) | Paid (~$25/mo) |
| **Security Level** | Basic (IAM only) | High (WAF + DDoS Protection) |
| **Complexity** | Low (Automatic) | Medium (Requires LB Setup) |
| **Best For** | Portfolios, Dev, Small Apps | Production, Enterprise, APIs |

---

## Requirements

### Software
- **Terraform**: `>= 1.0`
- **Google Provider**: `>= 4.0`

### Required GCP APIs
The module automatically attempts to enable:
- `run.googleapis.com`
- `artifactregistry.googleapis.com`
