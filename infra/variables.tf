variable "prefix" {
  description = "Resource name prefix (logiforma-prod or logiforma-dev)"
  type        = string
}

variable "domain" {
  description = "Root domain (logiforma.com or logiforma.dev)"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}
