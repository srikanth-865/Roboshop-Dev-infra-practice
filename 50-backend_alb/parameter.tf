resource "aws_ssm_parameter" "aws_alb_listner" {
  name  = "/${var.project}/${var.environment}/backend_alb_listener_arn"  #Roboshop1/Dev/mysql
  type  = "String"
  value = aws_lb_listener.http.arn
}