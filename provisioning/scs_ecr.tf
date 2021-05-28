
 module "scs_ecr" {
    source = "../src/scs_ecr"

    providers = {
    aws.scs-corpo-ecr_admin = aws
    }

    ecr_repo_name    = var.ecr_repo_name
}
