terraform {
  required_version = "0.13.6" 
  backend "s3" {
    bucket = "scs-aws-tf-state"
    key = "tfstate/test/terraform-module/scs_test/terraform.tfstate"
    region = "ca-central-1"
    role_arn = "arn:aws:iam::685683851314:role/scs_master_s3_state_write"
    dynamodb_table = "scs-terraform-state-lock-dynamodb"
  }
}





