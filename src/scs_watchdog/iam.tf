###############
# Lambdas IAM #
###############

# Read load Balancers / Target Groups
data "aws_iam_policy_document" "scs_allow_assume_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_read_lb_tg" {
  statement {
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_lb_target_groups_read" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "scs-aws-lb-target-groups-read"
  path        = "/"
  description = "Needed rights to read LoadBalancer Target groups"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_read_lb_tg.json
}

resource "aws_iam_role" "scs_lambda_read_lb_target_groups_read" {
  name = "scs-lambda-read-lb-target-group-read"
  assume_role_policy = data.aws_iam_policy_document.scs_allow_assume_lambda.json
}

resource "aws_iam_role_policy_attachment" "scs_lambda_lb_tg_read_attachement" {
  role       = aws_iam_role.scs_lambda_read_lb_target_groups_read.name
  policy_arn = module.iam_policy_aws_lb_target_groups_read.arn
}

resource "aws_iam_role_policy_attachment" "scs_lambda_execution_role" {
  role       = aws_iam_role.scs_lambda_read_lb_target_groups_read.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}