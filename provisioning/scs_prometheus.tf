module "scs_prometheus" {
    source = "../src/scs_prometheus"

    providers = {
    aws.scs-corpo-ecr_admin = aws 
    }

    vpc_id                     = module.scs_vpc.vpc_id
    subnet_ids                 = module.scs_vpc.private_subnets
    endpoint_authorized_cidr   = var.endpoint_authorized_cidr
    promxy_authorized_cidr     = var.promxy_authorized_cidr
    zone_id                    = module.scs_zone_route53.aws_route53_private_zone_id
    scs_workload               = var.scs_workload

} 