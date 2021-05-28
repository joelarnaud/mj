Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_vpc
        :name: Module scs_vpc

            module "scs_vpc" {

              source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_vpc"

              providers = {
                aws.scs-shared-read = "aws.shared-read"
                aws.scs-shared-transit_gateway = "aws.scs_shared_vpc"
                aws = "aws"
              }
              scs_vpc_cidr = "10.137.0.0/16"

              scs_intra_subnets = ["10.137.224.0/21", "10.137.232.0/21", "10.137.240.0/21"]
              scs_private_subnets = ["10.137.0.0/21", "10.137.8.0/21", "10.137.16.0/21"]
              scs_public_subnets = ["10.137.128.0/21", "10.137.136.0/21", "10.137.144.0/21"]

              scs_workload = "corpo"
              scs_environment = "dev"
              scs_vpc_number = "001"

              scs_vpc_transit_gateway_attach = false

              private_subnet_tags = var.private_subnet_tags
              public_subnet_tags  = var.public_subnet_tags

              global_tags = var.global_tags
              vpc_tgw_attachement_tags = {Name = "scs_aws_${var.scs_workload}_${var.scs_environment}_vpc_attachement_001" }
            }




Providers :
--------------


=========================================  ====================
Name                                       Version
=========================================  ====================
aws                                        n/a
aws.scs-shared-read                        n/a
aws.scs-shared-transit\_gateway            n/a
alias.shared-route53-write-record-in-zone  n/a
=========================================  ====================

Inputs :
----------

============================== ==========================================================================================  ==============  ===============================================================================================================
Name                           Description                                                                                 Type            Default
============================== ==========================================================================================  ==============  ===============================================================================================================
scs_workload                   The workload name to use for every intenal ressource. Ex : corpo, ag, ac ...                `string`        n/a
scs_environment                The workload environment to use for every intenal ressource. Ex : dev, pro, lab             `string`        n/a
global\_tags                   Generic tags for resources                                                                  `map`           { Terraform   = "true", Environment = "dev" }   no
private\_subnet\_tags          Private subnet tags                                                                         `map`           { Type: "private", "kubernetes.io/role/internal-elb": "1"}
public\_subnet\_tags           Public subnet tags                                                                          `map`           { Type: "public", "kubernetes.io/cluster/terraform-eks-cluster-dev-1": "shared", "kubernetes.io/role/elb": "1"}
scs\_intra\_subnets            Intra subnet range. Generally : ["10.XXX.224.0/21", "10.XXX.232.0/21", "10.XXX.240.0/21"]   `list(string)`  `[]`
scs\_internal\_ssq\_ips        The internal SSQ Classless inter-domain routing (CIDR)                                      `string`        `"10.0.0.0/8"`
scs\_aov\_ip                   The Always On VPN for SSQ IP (CIDR)                                                         `string`        `"172.27.64.0/18"`
scs\_private\_subnets          Private subnet range. Generally : ["10.XXX.0.0/21", "10.XXX.8.0/21", "10.XXX.16.0/21"]      `list(string)`  `[]`
scs\_public\_subnets           Public subnet range. Generally : ["10.XXX.128.0/21", "10.XXX.136.0/21", "10.XXX.144.0/21"]  `list(string)`  `[]`
scs\_ressource\_prefix         The prefix to use for every intenal ressource.                                              `string`        `"scs\_aws\_dev"`
scs_vpc_number                 The VPC number.                                                                             `string`        "001"
scs\_vpc\_cidr                 n/a                                                                                         `string`        n/a
vpc\_tgw\_attachement\_tags    VPC attachement tags                                                                        `map`           { Name: "scs_aws_vpc_tgw_attachement" }
scs_vpc_tags                   Generic tags for vpc                                                                        `map`           n/a
azs                            A list of availability zones names or ids in the region.                                    `list(string)`  ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
scs_vpc_transit_gateway_attach Attach the VPC to the transit gateway or not                                                `bool`          false
============================== ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

====================================  ================================================================
  Name                                Description
====================================  ================================================================
private_subnets                       List of IDs of private subnets
public_subnets                        List of IDs of public subnets
intra_subnets                         List of IDs of intra subnets
database_subnets                      List of IDs of database subnets
vpc\_id                               The ID of the VPC
default_security_group_id             The ID of the security group created by default on VPC creation
db_subnet_group_name                  Name of the database subnet created by the module
====================================  ================================================================

