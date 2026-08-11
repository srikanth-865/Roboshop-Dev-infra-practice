resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-{var.environment}.{var.domain_name}"  
  type    = "A"
  ttl     = 300
  records = aws_instance.mongodb.private_ip
}