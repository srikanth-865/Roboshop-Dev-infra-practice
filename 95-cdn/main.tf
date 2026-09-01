resource "aws_cloudfront_distribution" "roboshop" {

  origin {
    domain_name = "${var.project}-${var.environment}.${var.domain_name}"
    origin_id   = "${var.project}-${var.environment}.${var.domain_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  comment         = "Roboshop CloudFront Distribution"

  # CloudFront CDN hostname
  # roboshop1-cdn.srikanth865.online
  aliases = ["${lower(var.project)}-cdn.${lower(var.domain_name)}"]

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    cache_policy_id = local.cachingDisabled
  }

  # Cache behavior for media
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id        = local.cachingOptmized
  }

  # Cache behavior for videos
  ordered_cache_behavior {
    path_pattern     = "/videos/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id        = local.cachingOptmized
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(
    {
      Name = "${var.project}-${var.environment}"
    },
    local.common_tags
  )

  # Wildcard certificate:
  # *.srikanth865.online
  viewer_certificate {
    acm_certificate_arn = local.certificate_arn
    ssl_support_method  = "sni-only"
  }
}


resource "aws_route53_record" "www" {

  zone_id = var.zone_id

  # roboshop1-cdn.srikanth865.online
  name = "${lower(var.project)}-cdn.${lower(var.domain_name)}"

  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = true
  }
}