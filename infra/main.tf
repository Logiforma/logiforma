# ── Cloudflare Zone Lookup ────────────────────────────────────────
data "cloudflare_zones" "domain" {
  filter {
    name = var.domain
  }
}

locals {
  zone_id = data.cloudflare_zones.domain.zones[0].id
}

# ── S3 Bucket ────────────────────────────────────────────────────
resource "aws_s3_bucket" "site" {
  bucket = var.prefix
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── ACM Certificate ─────────────────────────────────────────────
resource "aws_acm_certificate" "site" {
  domain_name               = var.domain
  subject_alternative_names = ["www.${var.domain}"]
  validation_method         = "DNS"

  tags = {
    Name = var.prefix
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── ACM DNS Validation via Cloudflare ────────────────────────────
# Only creates the specific CNAME records needed for ACM validation.
# Does NOT touch any other DNS records.
resource "cloudflare_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.site.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 120
  proxied = false
}

resource "aws_acm_certificate_validation" "site" {
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for r in cloudflare_record.acm_validation : r.hostname]
}

# ── CloudFront Origin Access Control ────────────────────────────
resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.prefix}-oac"
  description                       = "OAC for ${var.prefix}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ── CloudFront Distribution ─────────────────────────────────────
resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  comment             = var.prefix
  default_root_object = "index.html"
  http_version        = "http2and3"
  price_class         = "PriceClass_100"
  aliases             = [var.domain, "www.${var.domain}"]

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "S3-${var.prefix}"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.prefix}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    # Managed CachingOptimized policy
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  # SPA routing: serve index.html for 403/404
  custom_error_response {
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 10
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.site.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [aws_acm_certificate_validation.site]
}

# ── S3 Bucket Policy for CloudFront ─────────────────────────────
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.site.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site.arn
          }
        }
      }
    ]
  })
}

# ── Cloudflare DNS Records ──────────────────────────────────────
# Only creates CNAME records for the apex and www subdomain.
# Does NOT list, delete, or modify any other DNS records.
resource "cloudflare_record" "apex" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "CNAME"
  content = aws_cloudfront_distribution.site.domain_name
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www" {
  zone_id = local.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  content = aws_cloudfront_distribution.site.domain_name
  ttl     = 1
  proxied = false
}
