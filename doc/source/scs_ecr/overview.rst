Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_ecr
        :name: Module scs_ecr

             module "scs-ecr-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_ecr?ref=terraform-module-1.0.11"
                ecr_repo_name = "scs/ca/ssq/ac/tiragebd"
                image_scan = true
                days_before_deletion = 7
            }

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
ecr_repo_name                 Ecr repository name. Ex : scs/ca/ssq/ac/tiragebd                                            `string`        n/a
image_scan                    Enable container image scanning on push, true or false                                      `bool`          true
days_before_deletion          Number of days before untagged images are deleted                                           `string`        7
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A
