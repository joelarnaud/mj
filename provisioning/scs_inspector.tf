module "scs_inspector" {
    source = "../src/scs_inspector"

    providers = {
    aws.scs-aws-account = aws.scs-lab-admin-us-east-1
    }

    assessment_name   = var.assessment_name 
    config_number     = var.config_number
} 
