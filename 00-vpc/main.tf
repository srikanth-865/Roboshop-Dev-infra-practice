module "vpc"{
    source = "git::https://github.com/srikanth-865/vpc-source-practice.git?ref=main"
    project = var.project
    environment = var.environment
}
