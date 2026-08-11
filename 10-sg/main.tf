module "sg" {
    count = length(var.sg_name)
    source = "git::https://github.com/srikanth-865/terraform-sg-practice.git?ref=main"
    project = var.project
    environment =  var.environment
    sg_name = var.sg_name[count.index]
    vpc_id = local.vpc_id
}