locals{
common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
                }
    common_name = "${var.project}-${var.environment}"
}