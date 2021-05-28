module "scs_bastion" {
    source = "../src/scs_bastion"

    providers = {
    aws.scs-aws-account = aws 
    }

    authorized_cidr  = var.authorized_cidr
    scs_workload     = var.scs_workload
    vpc_id           = module.scs_vpc.vpc_id
    subnet_ids       = module. scs_vpc.private_subnets
    zone_id          = module.scs_zone_route53.aws_route53_private_zone_id
} 
