#
# POLICY FOR LAMBDA
#

# PutEvaluation in Config and Cloudwatch rights for Lambda

data "aws_iam_policy_document" "scs_security_lambda_ingress" {
  statement {
    effect = "Allow"
    actions = [
      "config:PutEvaluations"
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

module "scs_policy_security_lambda_ingress" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "scs-policy-security-lambda-${var.scs-lambda-name}-ingress"
  path        = "/"
  description = "Allow actions for Lambda to update Config evaluation"

  policy = data.aws_iam_policy_document.scs_security_lambda_ingress.json
}

#
# ROLE for Lambda
#

data "aws_iam_policy_document" "scs_lambda_ingress_assume_role_policy" {
  statement {
    effect = "Allow"
    actions  = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "scs_lambda_ingress_role" {
  name = "scs-lambda-ingress-${var.scs-lambda-name}-role"

  assume_role_policy = data.aws_iam_policy_document.scs_lambda_ingress_assume_role_policy.json
}

#
# POLICY ATTACHMENT 
#

resource "aws_iam_role_policy_attachment" "scs_lambda_ingress_policy" {
  role       = aws_iam_role.scs_lambda_ingress_role.name
  policy_arn = module.scs_policy_security_lambda_ingress.arn
}

#
# LAMBDA
#

resource "null_resource" "download_lambda_ingress" {
  provisioner "local-exec" {
    command = "curl -k http://repo.ssqti.ca/repository/python-releases/packages/scs-aws-ingress-rules-lambda/${var.scs_lambda_version}/scs_aws_ingress_rules_lambda-${var.scs_lambda_version}-py3-none-any.whl --output ${path.module}/lambda-${var.scs_lambda_version}.zip "
  }
  triggers = {
    //To always run download
    always_run = timestamp()
  }
}

resource "aws_lambda_function" "scs_lambda_function_ingress" {
  description   = "Lambda permettant de vérifier la conformité des security groups en ingress"
  filename      = "${path.module}/lambda-${var.scs_lambda_version}.zip"
  function_name = "lambda-${var.scs-lambda-name}-ingress"
  role          = aws_iam_role.scs_lambda_ingress_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  timeout     = 900
  memory_size = 512
  depends_on = [null_resource.download_lambda_ingress]
}

# 
# CONFIG RULE
#

resource "aws_lambda_permission" "scs_lambda_ingress_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scs_lambda_function_ingress.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

resource "aws_config_config_rule" "scs_config_ingress_rule" {
  name          = "scs-config-ingress-rule"
  description   = "Custom rule to check compliance of ingress rules every time a change is done on SG"
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.scs_lambda_function_ingress.arn
    source_detail {
        event_source    = "aws.config"
        message_type    = "ConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    aws_lambda_permission.scs_lambda_ingress_permission
  ]
}