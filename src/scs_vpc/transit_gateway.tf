# pour adresse ip SSQ
resource "aws_route" "scs_aws_route_subnet_public_to_transit_gateway" {
  count = length(var.scs_public_subnets) > 0 && var.scs_vpc_transit_gateway_attach ? 1 : 0
  route_table_id            = module.scs_aws_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = var.scs_internal_ssq_ips
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}

resource "aws_route" "scs_aws_route_subnet_private_to_transit_gateway" {
  count = length(var.scs_private_subnets) > 0 && var.scs_vpc_transit_gateway_attach ?  length(var.scs_private_subnets) : 0
  route_table_id            = module.scs_aws_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = var.scs_internal_ssq_ips
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}


resource "aws_route" "scs_aws_route_subnet_database_to_transit_gateway" {
  count = length(var.scs_database_subnets) > 0 && var.scs_vpc_transit_gateway_attach? 1 : 0
  route_table_id            = module.scs_aws_vpc.database_route_table_ids[count.index]
  destination_cidr_block    = var.scs_internal_ssq_ips
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}

resource "aws_route" "scs_aws_route_vpc_to_transit_gateway" {
  count = var.scs_vpc_transit_gateway_attach? 1 : 0
  route_table_id            = module.scs_aws_vpc.vpc_main_route_table_id
  destination_cidr_block    = var.scs_internal_ssq_ips
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}

# pour adresse AOV
resource "aws_route" "scs_aws_route_subnet_public_aov_to_transit_gateway" {
  count = length(var.scs_public_subnets) > 0 && var.scs_vpc_transit_gateway_attach? 1 : 0
  route_table_id            = module.scs_aws_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = var.scs_aov_ip
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]

}

resource "aws_route" "scs_aws_route_subnet_private_aov_to_transit_gateway" {
  count = length(var.scs_private_subnets) > 0 && var.scs_vpc_transit_gateway_attach ?  length(var.scs_private_subnets) : 0
  route_table_id            = module.scs_aws_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = var.scs_aov_ip
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}


resource "aws_route" "scs_aws_route_subnet_database_aov_to_transit_gateway" {
  count = length(var.scs_database_subnets) > 0 && var.scs_vpc_transit_gateway_attach? 1 : 0
  route_table_id            = module.scs_aws_vpc.database_route_table_ids[count.index]
  destination_cidr_block    = var.scs_aov_ip
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}

resource "aws_route" "scs_aws_route_vpc_aov_to_transit_gateway" {
  count = var.scs_vpc_transit_gateway_attach? 1 : 0
  route_table_id            = module.scs_aws_vpc.vpc_main_route_table_id
  destination_cidr_block    = var.scs_aov_ip
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.scs_aws_vpc_attachement]
}

# fetch transit gateway from share
data "aws_ec2_transit_gateway" "scs_aws_tg_global_001" {
  filter {
    name   = "tag:Name"
    values = ["scs_aws_tg_global_001"]
  }

  provider = aws.scs-shared-read
}

// Create the VPC private subnet attachment in the Drakkar account
resource "aws_ec2_transit_gateway_vpc_attachment" "scs_aws_vpc_attachement" {
  count = var.scs_vpc_transit_gateway_attach? 1 : 0
  transit_gateway_id = data.aws_ec2_transit_gateway.scs_aws_tg_global_001.id
  vpc_id             = module.scs_aws_vpc.vpc_id
  subnet_ids         = module.scs_aws_vpc.private_subnets

  tags = merge(var.vpc_tgw_attachement_tags, var.global_tags)
}

// acceptation
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "scs_aws_vpc_attachement" {
  count = var.scs_vpc_transit_gateway_attach? 1 : 0
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.scs_aws_vpc_attachement[count.index].id

  tags = {
    Name = "scs_aws_${var.scs_workload}_${var.scs_environment}_vpc_attachement_${var.scs_vpc_number}"
    Side = "Accepter"
  }

  provider   = aws.scs-shared-transit_gateway
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.scs_aws_vpc_attachement]
}
