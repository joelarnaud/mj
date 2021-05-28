Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_eks_monitoring
        :name: Module scs_eks_monitoring

             module "scs-corpo-eks-monitoring-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_eks_monitoring?ref=terraform-module-2.x.y"
                scs_workload = "corpo"
                scs_environment = "dev"
                cluster_number = "001"
                eks_oidc_issuer_url = module.scs_eks_corpo_dev.eks_cluster_oidc_url
                elk_domain = "scs-ti-dev-elk"
                prom_node_exporter_version = "1.0.1"
                providers = {
                    aws = aws
                    aws.scs-workload-with-elk = aws.scs-ti-dev
                    helm.scs-helm = helm
                }
            }

On doit par la suite ajouter un provider aws pour recuperer des informations dans le compte scs-ti-dev ( FIXME )

.. code-block:: bash
        :caption: ajout au provider.tf
        :name: ajout provider scs-ti-dev-admin

             provider "aws" {
               version = "= 2.70.0"
               region  = "ca-central-1"
               alias   = "scs-shared-dev-admin-ca-central-1"
               assume_role {
                 role_arn = "arn:aws:iam::273972941115:role/scs-ti-dev-admin"
               }
             }

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
scs_workload                  The workload name to use for every intenal ressource. Ex : corpo, ag, ac ...                `string`        n/a
scs_environment               The workload environment to use for every intenal ressource. Ex : dev, pro, lab             `string`        n/a
cluster\_number               Number of the cluster                                                                       `string`        n/a
eks_oidc_issuer_url           Output oidc issuer url from eks module                                                      `variable`      n/a
elk_domain                    Name of the ELK domain                                                                      `string`        n/a
prom_node_exporter_version    Version of prometheus node exporter helm chart                                              `string`        1.0.1
providers                     Default and scs-shared-admin provider in your account ( dns resolve )                       `map`           n/a
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A