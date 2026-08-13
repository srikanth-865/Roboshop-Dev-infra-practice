resource "aws_ssm_parameter" "mysql-root-password" {
  name        = "/${var.project}/${var.environment}/mysql-root-password"
  description = "mysql password is to store on paramter store for encrytping purpose"
  type        = "SecureString"
  value       = var.mysql-password
}