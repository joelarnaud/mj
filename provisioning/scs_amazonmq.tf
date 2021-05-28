module "scs_amazonmq" {
    source = "../src/scs_amazonmq"

    providers = {
    aws.scs-aws-account = aws
    }

    broker_name          = var.broker_name
    admin_username       = var.admin_username
    admin_password       = var.admin_password
    application_username = var.application_username
    application_password = var.application_password 
    vpc_id               = module.scs_vpc.vpc_id
    subnet_ids           = module.scs_vpc.public_subnets
    allowed_protocols    = var.allowed_protocols 
    tags                 = var.tags  
}