###################
# Provider section#
###################
provider "aws" {
  alias   = "scs-shared-transit_gateway"
}

provider "aws" {
  alias   = "scs-shared-read"
}