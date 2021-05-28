Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_eks_pro_dns
        :name: Module scs_eks_pro_dns

             module "scs-corpo-pro-dns-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_eks_pro_dns?ref=terraform-module-2.1.xx"
                scs_workload = "corpo"
                scs_environment = "pro"
                cluster_number = "001"
                eks_oidc_issuer_url = module.scs_eks_corpo.eks_cluster_oidc_url
                providers = {
                  aws.scs-shared-admin = aws.scs-shared-admin
                  kubernetes = kubernetes.k8s-kubeconfig
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
providers                     Pass your kubernetes provider for scs-shared-admin provider                                                             `map`           n/a
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A