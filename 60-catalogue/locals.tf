 locals{
    catalogue_sg_id = data.aws_ssm_parameter.catalogue.value
    private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
                }
    common_name = "${var.project}-${var.environment}"
}
