variable "project" {
  default = "Roboshop1"
}
variable "environment" {
  default = "Dev"
}
 variable "sg_name" {
    type = list
  default = [
        "mongodb", "redis", "mysql", "rabbitmq",
        "catalogue", "user", "cart", "shipping", "payment",
        "backend-alb",
        "frontend",
        "frontend-alb",
        "bastion",
        "vpn"
  ]
} 