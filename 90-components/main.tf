module "component"{
    for_each = var.components
    source = "git::https://github.com/srikanth-865/terraform-roboshop-component.git?ref=main"
    component = each.key
    environment = var.environment
    app_version = each.value.app_version 
}