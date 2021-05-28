module "scs_lambda_ecr_scan" {
    source = "../src/scs_lambda_ecr_scan"

    providers = {
    aws.scs-aws-account = aws
    }

    schedule = var.schedule
} 