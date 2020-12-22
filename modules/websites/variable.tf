variable "dynamodb_properties" {
  type       = map(string)
}

variable "dynamodb_tags" {
  type       = map(string)
}

variable "env" {
  default    = ""
}

variable "s3_bucket_name" {
}

variable "bucket_versioning" {
  type       = bool
  default    = false
}

variable "bucket_index_document" {
  type       = string
  default    = "index.html"
}

variable "bucket_error_document" {
  type       = string
  default    = "index.html"
}

variable "s3_tags" {
  type       = map(string)
  default    = {}
}

variable "cloudfront_tags" {
  type       = map(string)
  default    = {}
}

variable "dns_zone" {
  type       = string
  default    = ""
}

###Cloudfront

variable "create_cloudfront" {
  type       = bool
  default    = true
}

variable "domain_name_cloudfront" {
  default    = ""
}

variable "enabled" {
  default    = true
}

variable "is_ipv6_enabled" {
  default    = false
}

variable "s3origin" {
  default    = "example-com"
}

variable "retain_on_delete" {
  default    = true
}

variable "cache_allowed_methods" {
  type       = list(string)
  default    = ["GET", "HEAD"]
}

variable "cache_cached_methods" {
  type       = list(string)
  default    = ["GET", "HEAD"]
}

variable "query_string" {
  default    = false
}

variable "cookies_forward" {
  default    = "none"
}

variable "viewer_protocol_policy" {
  default    = "allow-all"
}

variable "min_ttl" {
  default    = 0
}

variable "default_ttl" {
  default    = 3600
}

variable "max_ttl" {
  default    = 86400
}

variable "price_class" {
  default    = "PriceClass_100"
}

variable "geo_restriction_type" {
  default    = "whitelist"
}

variable "geo_restriction_locations" {
  type       = list(string)
  default    = ["PL","IE"]
}

variable "certificate_arn" {
  type       = string
  # cf default certificate
  default    = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
}

variable "ssl_support_method" {
  default    = "sni-only"
}

variable "create_cloudfront_dns" {
  type       = bool
  default    = false
}

variable "enable_waf" {
  type       = bool
  default    = false
}

# flag to upload simple site
variable "upload_sample_site" {
  type       = bool
  default    = true
}

variable "cloudfront_aliases" {
  type       = list(string)
  default    = [""]
}