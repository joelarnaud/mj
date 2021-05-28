resource "null_resource" "download_lambda_code" {
  provisioner "local-exec" {
    command = "curl -k http://repo.ssqti.ca/repository/python-releases/packages/scs-aws-lb-checker-lambda/${var.scs_lambda_version}/scs_aws_lb_checker_lambda-${var.scs_lambda_version}-py3-none-any.whl --output ${path.module}/lambda-${var.scs_lambda_version}.zip "
  }
  triggers = {
    //To always run download
    always_run = timestamp()
  }
}

resource "aws_lambda_function" "tg_orphans_detector" {
  description   = "Detects and reports tg with no targets associated"
  filename      = "${path.module}/lambda-${var.scs_lambda_version}.zip"
  function_name = "tg-orphans-detector"
  role          = aws_iam_role.scs_lambda_read_lb_target_groups_read.arn
  handler       = "lb_checker.lb_checker_handler"
  runtime       = "python3.6"

  timeout     = 900
  memory_size = 512

  depends_on = [null_resource.download_lambda_code]

}