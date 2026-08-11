locals{
    ami_id = data.aws_ami.srikanth.id
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_id.value)[0]
    common_tags = {
        project = var.project
        environment = var.environment
        Terraform = true
            }
    common_name = "${var.project}-${var.environment}"
}
