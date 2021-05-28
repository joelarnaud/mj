Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_lambda_parameter
        :name: Module scs_lambda_parameter

             module "scs-aws-master-svc-lambda-parameter-001" {
                source = "git::https://git.ssq.local/scm/infra/terraform-modules.git//src/scs_lambda_parameter?ref=terraform-module-2.0.12"
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