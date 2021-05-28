Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_lambda_ecr_scan
        :name: Module scs_lambda_ecr_scan

             module "scs-aws-master-svc-lambda-ecr-scan-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_lambda_ecr_scan?ref=terraform-module-2.1.8"
                providers = {
                    aws = aws
                }
            }

Providers :
--------------

======================================  ====================
Name                                    Version
======================================  ====================
aws                                     n/a
======================================  ====================

Inputs :
----------

Ce module ne nécessite aucun paramètre.

Outputs :
----------

N/A