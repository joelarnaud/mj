Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_svc_config
        :name: Module scs_svc_config

             module "scs-aws-master-svc-config-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_svc_config?ref=terraform-module-1.0.7"
                config_number = "001"
                bucket_name = "scs-aws-s3-config-hors-tower-001"
                providers = {
                    aws.scs-aws-account = aws.scs-aws-master-ca-central-1
                    aws.scs-aws-logs-ca = aws.scs-aws-logs-ca-central-1
                }
            }

Providers :
--------------


======================================  ====================
Name                                    Version
======================================  ====================
scs-aws-account                         n/a
aws.scs-aws-logs-ca                     n/a
======================================  ====================

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
config\_number                Config number                                                                               `string`        n/a
bucket\_name                  Bucket name where logs will be storer (normally in logs account)                            `string`        n/a
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A