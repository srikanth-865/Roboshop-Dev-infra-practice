resource "aws_ssm_parameter" "sg_id" {
  count = length(var.sg_name)
  name  = "/${var.project}/${var.environment}/${var.sg_name[count.index]}"  #Roboshop1/Dev/mysql
  type  = "String"
  value = module.sg[count.index].sg-ids
}