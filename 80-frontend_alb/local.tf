 locals{
    frontend-alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
    public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_ids.value)
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
                }
    common_name = "${var.project}-${var.environment}"
    certificate_arn = data.aws_ssm_parameter.certificate_arn.value
}
