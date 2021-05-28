module "scs_watchdog" {
    source = "../src/scs_watchdog"

    providers = {
    aws.scs-aws-account = aws
    }
  
}