#
# POLICY FOR LAMBDA
#

# Cloudwatch and SSM rights for Lambda

data "aws_iam_policy_document" "scs_security_lambda_ecr_scan" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "securityhub:BatchImportFindings",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
    resources = ["*"]
  }
  statement {
      effect = "Allow"
      actions = [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ]
      resources = ["arn:aws:logs:ca-central-1:*:*:*"]
  }
}

module "scs_policy_security_lambda_ecr_scan" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "scs-policy-security-lambda-ecr-scan"
  path        = "/"
  description = "Allow actions for Lambda to describe parameters from SSM"

  policy = data.aws_iam_policy_document.scs_security_lambda_ecr_scan.json
}

#
# ROLE for Lambda
#

data "aws_iam_policy_document" "scs_lambda_ecr_scan_assume_role_policy" {
  statement {
    effect = "Allow"
    actions  = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "scs_lambda_ecr_scan_role" {
  name = "scs-lambda-parameter-ecr-scan-role"

  assume_role_policy = data.aws_iam_policy_document.scs_lambda_ecr_scan_assume_role_policy.json
}

#
# POLICY ATTACHMENT 
#

resource "aws_iam_role_policy_attachment" "scs_lambda_policy_ecr_scan" {
  role       = aws_iam_role.scs_lambda_ecr_scan_role.name
  policy_arn = module.scs_policy_security_lambda_ecr_scan.arn
}

#
# LAMBDA
#

resource "null_resource" "download_lambda_ecr_scan" {
  provisioner "local-exec" {
    command = "curl -k http://repo.ssqti.ca/repository/python-releases/packages/scs-aws-ecr-vulnerabilities-lambda/${var.scs_lambda_version}/scs_aws_ecr_vulnerabilities_lambda-${var.scs_lambda_version}-py3-none-any.whl --output ${path.module}/lambda-${var.scs_lambda_version}.zip "
  }
  triggers = {
    //To always run download
    always_run = timestamp()
  }
}

resource "aws_lambda_function" "scs_lambda_function_ecr_scan" {
  description   = "Lambda permettant de vérifier les vulnérabilités dans les images dans ECR"
  filename      = "${path.module}/lambda-${var.scs_lambda_version}.zip"
  function_name = "lambda-ecr-scan"
  role          = aws_iam_role.scs_lambda_ecr_scan_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  timeout     = 900
  memory_size = 512
  depends_on = [null_resource.download_lambda_ecr_scan]

}

# 
# CLOUDWATCH EVENT and TARGET
#
resource "aws_cloudwatch_event_rule" "scs_check_ecr_scan" {
  name                = "CheckEcrVulnerabilities"
  description         = "Trigger Lambda to check if ECR images are vulnerable"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "scs_check_ecr_scan_target" {
  rule      = aws_cloudwatch_event_rule.scs_check_ecr_scan.name
  target_id = "lambda"
  arn       = aws_lambda_function.scs_lambda_function_ecr_scan.arn
}

resource "aws_lambda_permission" "scs_allow_cloudwatch_trigger_lambda_ecr_scan" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.scs_lambda_function_ecr_scan.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scs_check_ecr_scan.arn
}