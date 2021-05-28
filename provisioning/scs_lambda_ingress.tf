module "scs_lambda_ingress" {
    source = "../src/scs_lambda_ingress"

    providers = {
    aws.scs-aws-account = aws
    }

    scs-lambda-name = var.scs-lambda-name
    
} 