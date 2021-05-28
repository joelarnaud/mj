########
# Zone #
########

data "aws_route53_zone" "scs_aws_route53_interne" {
  name         = var.scs_environment == "pro" ? "scs.aws.interne" : "scs-${var.scs_environment}.aws.interne"
  private_zone = true
  provider     = aws.shared-route53-write-record-in-zone
}

resource "aws_route53_zone" "scs_aws_route53_private" {
  name = var.scs_workload == "lab" ? "${var.scs_workload}-${var.scs_vpc_number}.${data.aws_route53_zone.scs_aws_route53_interne.name}":"${var.scs_workload}.${data.aws_route53_zone.scs_aws_route53_interne.name}"

  lifecycle {
    ignore_changes = [vpc]
  }

  dynamic "vpc" {
    for_each = var.scs_vpc_ids
    content {
            vpc_id = vpc.value
    }
  }
}

# Registration to parent zone
resource "aws_route53_record" "scs_aws_route53_zone_registration" {
  allow_overwrite = true
  name            = "${var.scs_workload}.${data.aws_route53_zone.scs_aws_route53_interne.name}"
  ttl             = 3600
  # TTL 172800 en production FIXME
  type    = "NS"
  zone_id = data.aws_route53_zone.scs_aws_route53_interne.zone_id

  records  = aws_route53_zone.scs_aws_route53_private.name_servers
  provider = aws.shared-route53-write-record-in-zone
}

########################################
# Register VPC to scs-shared resolvers #
########################################

# SSQ.LOCAL
data "aws_route53_resolver_rule" "scs-shared-outbound-resolver" {
  name      = "ssq_local_outbound_endpoint"
  rule_type = "FORWARD"
  provider  = aws.scs-shared-read
}

resource "aws_route53_resolver_rule_association" "scs-shared-outbound-resolver" {
  count = length(var.scs_vpc_ids)

  resolver_rule_id = data.aws_route53_resolver_rule.scs-shared-outbound-resolver.id
  vpc_id           = var.scs_vpc_ids[count.index]
}

# SSQ.EXTRANET
data "aws_route53_resolver_rule" "scs-shared-outbound-resolver-extranet" {
  name      = "ssq_extranet_outbound_endpoint"
  rule_type = "FORWARD"
  provider  = aws.scs-shared-read
}

resource "aws_route53_resolver_rule_association" "scs-shared-outbound-resolver-extranet" {
  count = length(var.scs_vpc_ids)

  resolver_rule_id = data.aws_route53_resolver_rule.scs-shared-outbound-resolver-extranet.id
  vpc_id           = var.scs_vpc_ids[count.index]
}

# SSQ.CA
data "aws_route53_resolver_rule" "scs-shared-outbound-resolver-ssq-ca" {
  name      = "ssq_ca_outbound_endpoint"
  rule_type = "FORWARD"
  provider  = aws.scs-shared-read
}

resource "aws_route53_resolver_rule_association" "scs-shared-outbound-ssq-ca-resolver" {
  count = length(var.scs_vpc_ids)

  resolver_rule_id = data.aws_route53_resolver_rule.scs-shared-outbound-resolver-ssq-ca.id
  vpc_id           = var.scs_vpc_ids[count.index]
}

# SSQTI.CA
data "aws_route53_resolver_rule" "scs-shared-outbound-resolver-ssqti-ca" {
  name      = "ssqti_ca_outbound_endpoint"
  rule_type = "FORWARD"
  provider  = aws.scs-shared-read
}

resource "aws_route53_resolver_rule_association" "scs-shared-outbound-resolver-ssqti-ca" {
  count = length(var.scs_vpc_ids)

  resolver_rule_id = data.aws_route53_resolver_rule.scs-shared-outbound-resolver-ssqti-ca.id
  vpc_id           = var.scs_vpc_ids[count.index]
}

###########################################
# Register Route53 zone in scs-shared VPC #
###########################################

data "aws_vpc" "scs-shared-vpc" {
  filter {
    name   = "tag:Name"
    values = ["scs_aws_vpc_shared_001"]
  }
  provider = aws.scs-shared-read
}


data "external" "create_remote_zone_auth" {
  program    = ["bash", "${path.module}/createRemoteZoneAuth.sh", "var.account_admin_role", "aws_route53_zone.scs_aws_route53_private.zone_id", "data.aws_vpc.scs-shared-vpc.id"]
}


data "external" "create_remote_zone_assoc" {
  program    = ["bash", "${path.module}/createRemoteZoneAssoc.sh", "arn:aws:iam::433887757690:role/scs_shared_route53_zone_to_vpc_association", "aws_route53_zone.scs_aws_route53_private.zone_id", "data.aws_vpc.scs-shared-vpc.id"]
  depends_on = [data.external.create_remote_zone_auth]
}
