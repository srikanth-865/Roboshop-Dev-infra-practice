resource "aws_cloudfront_distribution" "roboshop" {
  
  origin {
    domain_name              = "${var.project}-${var.environment}.${var.domain_name}"
    origin_id                = "${var.project}-${var.environment}.${var.domain_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # Enforce HTTPS to ALB
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Some comment"

# CDN name  
  aliases = ["${lower(var.project)}-cdn.${lower(var.domain_name)}"] #Roboshop1-cdn.srikanth865.online we give

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    cache_policy_id = local.cachingDisabled  #if we didint select any invalidation default caching Disabled is set
  }
    # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptmized #its for media validation anything changed on media we validate on edge locations updated with new onw
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/videos/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.environment}.${var.domain_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptmized #its for video validation anything changed on media we validate on edge locations updated with new onw
  }
  

   restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = ["US", "CA", "GB", "DE"] #we didint restrict any locations
    }
  }

  tags = merge(
    {
        Name = "${var.project}-${var.environment}"
    },
    local.common_tags
  )

  viewer_certificate {
    acm_certificate_arn = local.certificate_arn  #as we generate certiface by acm we putting here for frontend trusted site
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "${var.project}-cdn.srikanth865.online" #Roboshop1-cdn.srikanth865.online its our URL for searching on website
  type    = "A"

  alias {
    # AWS details
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}