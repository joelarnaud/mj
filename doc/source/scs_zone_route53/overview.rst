Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_zone_route53
        :name: Module scs_zone_route53

            module "scs_zone_route53" {

              source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_zone_route53"
              account_admin_role = "arn:aws:iam::345154063299:role/scs-corpo-dev-admin"

              providers = {
                aws.scs-shared-read = "aws.shared-read"
                aws = "aws"
                aws.shared-route53-write-record-in-zone = "aws.shared-route53-write-record-in-zone"
              }

              scs_workload = "corpo"
              scs_environment = "dev"

              # Use only in lab
              scs_vpc_number = "your_vpc_number_here"

              scs_vpc_ids = [module.scs_aws_vpc_dev_001.vpc_id]

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

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
account_admin_role            ARN of the role who has admin rights in the account                                         `string`        n/a
scs_workload                  The workload name to use for every intenal ressource. Ex : corpo, ag, ac ...                `string`        n/a
scs_environment               The workload environment to use for every intenal ressource. Ex : dev, pro, lab             `string`        n/a
scs_vpc_ids                   The list of vpc Ids.                                                                        List            []
scs_vpc_number                Append zone name with vpc number in LAB                                                     `string`        "002"
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

====================================  ================================================================
  Name                                Description
====================================  ================================================================
aws_route53_private_zone_id           The private zone id for route 53
====================================  ================================================================

