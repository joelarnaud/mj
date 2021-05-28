# Création pour région ca-central-1
provider "aws" {
  alias = "scs-aws-account"
}

provider "aws" {
  alias = "scs-aws-logs-ca"
}

data "aws_s3_bucket" "scs-aws-s3-config" {
  bucket = var.bucket_name
  provider   = aws.scs-aws-logs-ca
}

resource "aws_config_delivery_channel" "scs_aws_config_delivery" {
  name           = "scs_aws_config_delivery_${var.config_number}"
  s3_bucket_name = data.aws_s3_bucket.scs-aws-s3-config.bucket
  depends_on     = [aws_config_configuration_recorder.scs_aws_config_recorder]
  provider   = aws.scs-aws-account
}

resource "aws_config_configuration_recorder" "scs_aws_config_recorder" {
  name     = "scs_aws_config_recorder_${var.config_number}"
  role_arn = aws_iam_role.scs_aws_role_config.arn
  provider   = aws.scs-aws-account
  recording_group {
    all_supported = false
    resource_types = [
      "AWS::ACM::Certificate",
      "AWS::ApiGateway::DomainName",
      "AWS::ApiGateway::RestApi",
      "AWS::ApiGateway::Stage",
      "AWS::ApiGatewayV2::DomainName",
      "AWS::ApiGateway::Method",
      "AWS::ApiGatewayV2::Api",
      "AWS::AutoScaling::AutoScalingGroup",
      "AWS::AutoScaling::LaunchConfiguration",
      "AWS::AutoScaling::ScalingPolicy",
      "AWS::AutoScaling::ScheduledAction",
      "AWS::CloudFormation::Stack",
      "AWS::CloudFront::Distribution",
      "AWS::CloudFront::StreamingDistribution",
      "AWS::CloudTrail::Trail",
      "AWS::CloudWatch::Alarm",
      "AWS::CodeBuild::Project",
      "AWS::CodePipeline::Pipeline",
      "AWS::Config::ResourceCompliance",
      "AWS::DynamoDB::Table",
      "AWS::EC2::CustomerGateway",
      "AWS::EC2::EgressOnlyInternetGateway",
      "AWS::EC2::EIP",
      "AWS::EC2::FlowLog",
      "AWS::EC2::Host",
      "AWS::EC2::Instance",
      "AWS::EC2::InternetGateway",
      "AWS::EC2::NatGateway",
      "AWS::EC2::NetworkAcl",
      "AWS::EC2::NetworkInterface",
      "AWS::EC2::RegisteredHAInstance",
      "AWS::EC2::RouteTable",
      "AWS::EC2::SecurityGroup",
      "AWS::EC2::Subnet",
      "AWS::EC2::Volume",
      "AWS::EC2::VPC",
      "AWS::EC2::VPCEndpoint",
      "AWS::EC2::VPCEndpointService",
      "AWS::EC2::VPCPeeringConnection",
      "AWS::EC2::VPNConnection",
      "AWS::EC2::VPNGateway",
      "AWS::ElasticBeanstalk::Application",
      "AWS::ElasticBeanstalk::ApplicationVersion",
      "AWS::ElasticBeanstalk::Environment",
      "AWS::ElasticLoadBalancing::LoadBalancer",
      "AWS::ElasticLoadBalancingV2::LoadBalancer",
      "AWS::Elasticsearch::Domain",
      "AWS::IAM::Group",
      "AWS::IAM::Policy",
      "AWS::IAM::Role",
      "AWS::IAM::User",
      "AWS::KMS::Key",
      "AWS::Lambda::Alias",
      "AWS::Lambda::Function",
      "AWS::LicenseManager::LicenseConfiguration",
      "AWS::MobileHub::Project",
      "AWS::QLDB::Ledger",
      "AWS::RDS::DBCluster",
      "AWS::RDS::DBClusterParameterGroup",
      "AWS::RDS::DBClusterSnapshot",
      "AWS::RDS::DBInstance",
      "AWS::RDS::DBOptionGroup",
      "AWS::RDS::DBParameterGroup",
      "AWS::RDS::DBSecurityGroup",
      "AWS::RDS::DBSnapshot",
      "AWS::RDS::DBSubnetGroup",
      "AWS::RDS::EventSubscription",
      "AWS::Redshift::Cluster",
      "AWS::Redshift::ClusterParameterGroup",
      "AWS::Redshift::ClusterSecurityGroup",
      "AWS::Redshift::ClusterSnapshot",
      "AWS::Redshift::ClusterSubnetGroup",
      "AWS::Redshift::EventSubscription",
      "AWS::SecretsManager::Secret",
      "AWS::ServiceCatalog::CloudFormationProduct",
      "AWS::ServiceCatalog::CloudFormationProvisionedProduct",
      "AWS::ServiceCatalog::Portfolio",
      "AWS::Shield::Protection",
      "AWS::ShieldRegional::Protection",
      "AWS::SNS::Topic",
      "AWS::SQS::Queue",
      "AWS::SSM::AssociationCompliance",
      "AWS::SSM::ManagedInstanceInventory",
      "AWS::SSM::PatchCompliance",
      "AWS::WAF::RateBasedRule",
      "AWS::WAF::Rule",
      "AWS::WAF::RuleGroup",
      "AWS::WAF::WebACL",
      "AWS::WAFRegional::RateBasedRule",
      "AWS::WAFRegional::Rule",
      "AWS::WAFRegional::RuleGroup",
      "AWS::WAFRegional::WebACL",
      "AWS::WAFv2::WebACL",
      "AWS::WAFv2::RuleGroup",
      "AWS::WAFv2::IPSet",
      "AWS::WAFv2::RegexPatternSet",
      "AWS::WAFv2::ManagedRuleSet",
      "AWS::XRay::EncryptionConfig"
    ]
  }
}

resource "aws_config_configuration_recorder_status" "scs_aws_conf_recorder_status" {
  name       = aws_config_configuration_recorder.scs_aws_config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.scs_aws_config_delivery]
  provider   = aws.scs-aws-account
}

data "aws_iam_policy_document" "scs_aws_assumerole_policy" {
  provider   = aws.scs-aws-account
  statement {
    effect    = "Allow"
    actions   = [
                "sts:AssumeRole"
      ]
    principals {
      type    = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "scs_aws_role_config" {
  provider   = aws.scs-aws-account
  name = "scs_aws_role_config_${var.config_number}"
  assume_role_policy = data.aws_iam_policy_document.scs_aws_assumerole_policy.json
}

data "aws_iam_policy_document" "scs_aws_bucket_config_policy" {
  provider   = aws.scs-aws-account
  statement {
    effect    = "Allow"
    actions   = [
                "s3:*"
      ]
    resources = [
      data.aws_s3_bucket.scs-aws-s3-config.arn,
      "${data.aws_s3_bucket.scs-aws-s3-config.arn}/*"
      ]
  }
}

resource "aws_iam_role_policy" "scs_aws_role_config_policy" {
  provider   = aws.scs-aws-account
  name = "scs_aws_role_config_policy_${var.config_number}"
  role = aws_iam_role.scs_aws_role_config.id
  policy = data.aws_iam_policy_document.scs_aws_bucket_config_policy.json
}

resource "aws_iam_role_policy_attachment" "scs_aws_role_attach_config" {
  provider   = aws.scs-aws-account
  role       = aws_iam_role.scs_aws_role_config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
