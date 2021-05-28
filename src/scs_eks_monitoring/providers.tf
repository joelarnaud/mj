###################
# Provider section#
####################
provider "aws" {
  alias   = "scs-workload-with-elk"
}

provider "helm" {
  alias   = "scs-helm"
}