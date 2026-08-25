#creating a load balancer
resource "aws_lb" "frontend_alb" {
  name               = "${local.common_name}-frontend-alb" # roboshop-dev-frontend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.frontend-alb_sg_id]
  subnets            = local.public_subnet_id

  enable_deletion_protection = false

  tags = merge(
    {
        Name = "${local.common_name}-frontend-alb"
    },
    local.common_tags
  )
}
#we are going to attach the listner for giving responce of load balancer
resource "aws_lb_listener" "https" {
   load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  
  # Recommended secure TLS policy
  ssl_policy        =  "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn.value
  
   default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

#its an optional means dns we gave to r53 with our name 
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "${var.project}-${var.environment}.srikanth865.online" #this for frontend so we give Roboshop1-Dev.srikanth865.online
  type    = "A"

  alias {
    # AWS details
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}