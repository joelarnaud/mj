
module "scs_vpc" {
    source = "../src/scs_vpc"

    providers = {
      aws.scs-shared-transit_gateway = aws.scs-shared-transit_gateway
      aws.scs-shared-read            = aws.scs-shared-read 
      aws.scs-aws-account            = aws
    }

    scs_private_subnets = var.scs_private_subnets
    scs_public_subnets  = var.scs_public_subnets
    scs_vpc_cidr        = var.scs_vpc_cidr
    scs_workload        = var.scs_workload
    scs_vpc_number      = var.scs_vpc_number
}