data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue"
}

data "aws_ssm_parameter" "user_sg_id" {
  name = "/${var.project}/${var.environment}/user"
}

data "aws_ssm_parameter" "cart_sg_id" {
  name = "/${var.project}/${var.environment}/cart"
}

data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project}/${var.environment}/shipping"
}

data "aws_ssm_parameter" "payment_sg_id" {
  name = "/${var.project}/${var.environment}/payment"
}

data "aws_ssm_parameter" "backend-alb_sg_id" {
  name = "/${var.project}/${var.environment}/backend-alb"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.environment}/frontend"
}

data "aws_ssm_parameter" "frontend-alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend-alb"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion"
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}