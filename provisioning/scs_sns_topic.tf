module "scs_sns_topic" {
    source = "../src/scs_sns_topic"

    providers = {
    aws.scs-corpo-ecr_admin = aws
    }

    topic_name        = var.topic_name 
    principal_service = var.principal_service
} 