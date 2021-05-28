module "scs_elasticache" {
    source = "../src/scs_elasticache"

    providers = {
    aws.scs-corpo-ecr_admin = aws
    }

    cluster_name  = var.cluster_name
    auth_token    = var.auth_token 
    vpc_id        = module.scs_vpc.vpc_id
    subnet_ids    = module.scs_vpc.private_subnets
    tags = var.tags
} 