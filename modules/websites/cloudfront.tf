resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment                             = "Allow Cloudfront to access S3 ${aws_s3_bucket.s3_bucket.bucket}"
}

locals {
  cloudfront_aliases                  = ["${var.env}.example.com"]
}

resource "aws_cloudfront_distribution" "cdn" {
  count                               = var.create_cloudfront ? 1 : 0
  origin {
    domain_name                       = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id                         = aws_s3_bucket.s3_bucket.bucket
    s3_origin_config {
      origin_access_identity          = aws_cloudfront_origin_access_identity.cdn.cloudfront_access_identity_path
    }
  }
  enabled                             = var.enabled
  is_ipv6_enabled                     = var.is_ipv6_enabled
  comment                             = "${var.env}-s3-cloudfront"
  default_root_object                 = "index.html"
  // this parameter is optional for custom domain
  //aliases                             = compact(concat(local.cloudfront_aliases, var.cloudfront_aliases))
  retain_on_delete                    = var.retain_on_delete
  web_acl_id                          = aws_waf_web_acl.waf_acl.id
  default_cache_behavior {
    allowed_methods                   = var.cache_allowed_methods
    cached_methods                    = var.cache_cached_methods
    target_origin_id                  = aws_s3_bucket.s3_bucket.bucket
    lambda_function_association {
      event_type                      = "viewer-request"
      lambda_arn                      = aws_lambda_function.lambda.qualified_arn
      include_body                    = false
    }
    forwarded_values {
      query_string                    = var.query_string

      cookies {
        forward                       = var.cookies_forward
      }
    }
    viewer_protocol_policy            = var.viewer_protocol_policy
    min_ttl                           = var.min_ttl
    default_ttl                       = var.default_ttl
    max_ttl                           = var.max_ttl
  }
  price_class                         = var.price_class
  restrictions {
    geo_restriction {
      restriction_type                = var.geo_restriction_type
      locations                       = var.geo_restriction_locations
    }
  }
  tags                                = var.cloudfront_tags
  viewer_certificate {
    cloudfront_default_certificate    = true
//    acm_certificate_arn             = var.certificate_arn
    ssl_support_method                = var.ssl_support_method
  }
}