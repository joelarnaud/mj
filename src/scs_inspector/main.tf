# Création pour région ca-central-1
provider "aws" {
  alias = "scs-aws-account"
}

resource "aws_inspector_resource_group" "scs_aws_inspector_rg" {
  provider = aws.scs-aws-account
  tags     = var.group_tag
}

resource "aws_inspector_assessment_target" "scs_aws_inspector_target" {
  provider           = aws.scs-aws-account
  name               = "assessment target"
  resource_group_arn = aws_inspector_resource_group.scs_aws_inspector_rg.arn
}

resource "aws_inspector_assessment_template" "scs_aws_inspector_template" {
  provider   = aws.scs-aws-account
  name       = "standard scs template"
  target_arn = aws_inspector_assessment_target.scs_aws_inspector_target.arn
  duration   = 3600
  rules_package_arns = var.rules_package
}
