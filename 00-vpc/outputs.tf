output "vpc_id"{
    value = module.vpc.vpc_id
}

output "public_subnet_ids"{
    value = module.vpc.public_subnet_ids
}

output "private_subnet_ids"{
    value = module.vpc.public_subnet_ids
}

output "databse_subnet_ids"{
    value = module.vpc.public_subnet_ids
}