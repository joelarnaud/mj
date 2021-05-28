Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_svc_inspector
        :name: Module scs_svc_inspector

             module "scs-aws-master-svc-inspector-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_svc_inspector?ref=terraform-module-1.X.X"
                config_number = "001"
                groupe_tag = {
                    Terraform = "true"
                }
                providers = {
                    aws.scs-aws-account = "aws.scs-aws-master-ca-central-1"
                }
                assessment_name = "Scan des ressources Terraform"
            }

Providers :
--------------


======================================  ====================
Name                                    Version
======================================  ====================
scs-aws-account                         n/a
======================================  ====================

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
config\_number                Config number                                                                               `string`        n/a
assessment\_name              Name of the scan which will be created                                                      `string`        n/a
groupe\_tag                   List of tags to use to select ressources to scan                                            `string`        n/a
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A