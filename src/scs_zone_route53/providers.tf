###################
# Provider section#
###################
provider "aws" {
  alias   = "scs-shared-read"
}

provider "aws" {
  alias   = "shared-route53-write-record-in-zone"
}
