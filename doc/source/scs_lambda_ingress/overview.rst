Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_lambda_ingress
        :name: Module scs_lambda_ingress

             module "scs-aws-master-svc-lambda-ingress-001" {
                source = "git::https://git.ssq.local/scm/infra/terraform-modules.git//src/scs_lambda_ingress?ref=terraform-module-2.0.12"
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