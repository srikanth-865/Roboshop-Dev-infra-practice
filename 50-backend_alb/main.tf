resource "aws_lb" "backend_alb" {
  name               = "${local.common_name}-backend_alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend-alb_sg_id]
  subnets            = [local.private_subnet_id]

  enable_deletion_protection = false

  tags =  merge(
    local.common_tags,
    {
        Name = "${local.common_name}-backend_alb"
    }
  )
}

resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-responces"

   fixed_response {
      content_type = "text/plain"
      message_body = "<h1> Hi i am from HTTP 80 port  backend_alb</h1>"
      status_code  = "200"
    }
  }
}

