provider "aws" {
  version = "= 3.16.0"
  region  = "ca-central-1"
  assume_role {
    //LAB admin
    role_arn = "arn:aws:iam::821957301576:role/scs-lab-admin"
  }
}

provider "aws" {  
  version = "= 3.16.0"
  region = "ca-central-1"
  alias   = "scs-shared-read"
  assume_role {
    role_arn = "arn:aws:iam::433887757690:role/scs-shared-read"
  }
}

provider "aws" {  
  version = "= 3.16.0"
  region = "ca-central-1"
  alias   = "scs-shared-transit_gateway"
  assume_role {
    role_arn = "arn:aws:iam::433887757690:role/scs_shared_vpc_transit_gateway_attachment"
  }
}

provider "aws" {
  version = "= 3.16.0"
  region  = "ca-central-1"
  alias   = "shared-route53-write-record-in-zone"
  assume_role {
    role_arn = "arn:aws:iam::433887757690:role/scs-shared-route53-write-record"
  }
}

provider "aws" {
  version = "= 3.16.0"
  region  = "us-east-1"
  alias = "scs-lab-admin-us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::821957301576:role/scs-lab-admin"
  }
}


 