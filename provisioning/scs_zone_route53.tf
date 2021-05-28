
module "scs_zone_route53" {
    source = "../src/scs_zone_route53"

    providers = {
      aws.shared-route53-write-record-in-zone = aws.shared-route53-write-record-in-zone
      aws.scs-shared-read                     = aws.scs-shared-read 
      aws.scs-aws-account                     = aws
    }

    account_admin_role   = var.account_admin_role
    scs_workload         = var.scs_workload 
    scs_vpc_ids          = [module.scs_vpc.vpc_id]
    scs_vpc_number       = "002"
}