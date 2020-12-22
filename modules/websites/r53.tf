resource "aws_route53_record" "domain" {
  count                         = var.create_cloudfront_dns ? 1 : 0
  zone_id                       = var.dns_zone
  name                          = ""

  type                          = "A"

  alias {
    evaluate_target_health      = true
    zone_id                     = aws_cloudfront_distribution.cdn[0].hosted_zone_id
    name                        = aws_cloudfront_distribution.cdn[0].domain_name
  }
}