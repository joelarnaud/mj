module "scs_lambda_parameter" {
    source = "../src/scs_lambda_parameter"

    providers = {
    aws.scs-aws-account = aws
    }

    schedule        = var.schedule
    scs-lambda-name = var.scs-lambda-name

} 