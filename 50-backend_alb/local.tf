 locals{
    backend-alb_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    private_subnet_id = split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0] 
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
                }
    common_name = "${var.project}-${var.environment}"
}
