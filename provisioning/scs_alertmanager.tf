######################
# scs_alertmanager   #
######################

module "scs_alertmanager" {
    source                     = "../src/scs_alertmanager"

    providers                  = {aws.scs-aws-account        = aws}

    vpc_id                     = module.scs_vpc.vpc_id
    subnet_ids                 = module.scs_vpc.private_subnets
    zone_id                    = module.scs_zone_route53.aws_route53_private_zone_id
    endpoint_authorized_cidr   = var.endpoint_authorized_cidr
    cluster_authorized_cidr    = var.cluster_authorized_cidr
    dashboard_authorized_cidr  = var.dashboard_authorized_cidr 
    scs_workload               = var.scs_workload 
    scs_environment            = var.scs_environment
}

  
