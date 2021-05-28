#
# POLICY FOR LAMBDA
#

# Cloudwatch and SSM rights for Lambda

data "aws_iam_policy_document" "scs_security_lambda_parameter" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "securityhub:BatchImportFindings"
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

module "scs_policy_security_lambda_parameter" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "scs-policy-security-lambda-${var.scs-lambda-name}-parameter"
  path        = "/"
  description = "Allow actions for Lambda to describe parameters from SSM"

  policy = data.aws_iam_policy_document.scs_security_lambda_parameter.json
}

#
# ROLE for Lambda
#

data "aws_iam_policy_document" "scs_lambda_parameter_assume_role_policy" {
  statement {
    effect = "Allow"
    actions  = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "scs_lambda_parameter_role" {
  name = "scs-lambda-parameter-${var.scs-lambda-name}-role"

  assume_role_policy = data.aws_iam_policy_document.scs_lambda_parameter_assume_role_policy.json
}

#
# POLICY ATTACHMENT 
#

resource "aws_iam_role_policy_attachment" "scs_lambda_policy" {
  role       = aws_iam_role.scs_lambda_parameter_role.name
  policy_arn = module.scs_policy_security_lambda_parameter.arn
}

#
# LAMBDA
#

resource "null_resource" "download_lambda_parameter" {
  provisioner "local-exec" {
    command = "curl -k http://repo.ssqti.ca/repository/python-releases/packages/scs-aws-parameter-compliance-lambda/${var.scs_lambda_version}/scs_aws_parameter_compliance_lambda-${var.scs_lambda_version}-py3-none-any.whl --output ${path.module}/lambda-${var.scs_lambda_version}.zip "
  }
  triggers = {
    //To always run download
    always_run = timestamp()
  }
}

resource "aws_lambda_function" "scs_lambda_function_parameter" {
  description   = "Lambda permettant de vérifier la conformité des paramètres dans SSM"
  filename      = "${path.module}/lambda-${var.scs_lambda_version}.zip"
  function_name = "lambda-${var.scs-lambda-name}-parameter"
  role          = aws_iam_role.scs_lambda_parameter_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  timeout     = 900
  memory_size = 512
  depends_on = [null_resource.download_lambda_parameter]

}

# 
# CLOUDWATCH EVENT and TARGET
#
resource "aws_cloudwatch_event_rule" "scs_check_parameter_compliance" {
  name                = "CheckParameterCompliance"
  description         = "Trigger Lambda to check if Parameters are encrypted"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "scs_check_parameter_target" {
  rule      = aws_cloudwatch_event_rule.scs_check_parameter_compliance.name
  target_id = "lambda"
  arn       = aws_lambda_function.scs_lambda_function_parameter.arn
}

resource "aws_lambda_permission" "scs_allow_cloudwatch_trigger_lambda_parameter" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.scs_lambda_function_parameter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scs_check_parameter_compliance.arn
}