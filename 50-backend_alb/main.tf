#creating a load balancer
resource "aws_lb" "backend_alb" {
  name               = "${local.common_name}-backend-alb" # roboshop-dev-backend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend-alb_sg_id]
  subnets            = local.private_subnet_id

  enable_deletion_protection = false

  tags = merge(
    {
        Name = "${local.common_name}-backend-alb"
    },
    local.common_tags
  )
}
#we are going to attach the listner for giving responce of load balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTP Backend ALB</h1>"
      status_code  = "200"
    }
  }
}

#its an optional means dns we gave to r53 with our name 
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}" # *.backend-alb-Dev.srikanth865.online
  type    = "A"

  alias {
    # AWS details
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}