###################
# VPC section     #
###################
module "scs_aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name    = "scs_aws_${var.scs_workload}_${var.scs_environment}_vpc_${var.scs_vpc_number}"
  cidr    = var.scs_vpc_cidr
  version = "2.64.0"

  azs = var.azs
  private_subnets = var.scs_private_subnets
  public_subnets  = var.scs_public_subnets
  intra_subnets   = var.scs_intra_subnets

  database_subnets = var.scs_database_subnets
  create_database_subnet_group = length(var.scs_database_subnets) > 0 ? true : false
  create_database_subnet_route_table = length(var.scs_database_subnets) > 0 ? true : false

  private_subnet_suffix  = "private"
  public_subnet_suffix   = "public"
  database_subnet_suffix = "database"

  enable_nat_gateway = length(var.scs_public_subnets) > 0 ? true : false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  vpc_tags = var.scs_vpc_tags
  tags = var.global_tags

  private_subnet_tags = merge({"Type" = "private"},var.private_subnet_tags)
  public_subnet_tags  = merge({"Type" = "public"},var.public_subnet_tags)
}