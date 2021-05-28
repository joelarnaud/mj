Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_istio
        :name: Module scs_istio

             module "scs-istio-001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_istio?ref=terraform-module-3.x.x"
                cluster_oidc_issuer_url = module.scs_eks_lab_dev.eks_cluster_oidc_url
            }

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
cluster\_oidc\_issuer\_url    Kubernetes cluster oidc url (outputted by eks module)                                       `string`        n/a
name                          Custom name for istio installation (used to salt helm release name and ressources)          `string`        default
namespace_name                Kubernetes namespace where istio will be installed (namespace will be created)              `string`        istio-system
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

========================================  ==================================================================================================================================================================
Name                                      Description
========================================  ==================================================================================================================================================================
namespace_name                            Kubernetes namespace where istio installed
istio\_ingress\_controller\_role\_arn     ARN of the role created in order to handle network load balancer provisionning
========================================  ==================================================================================================================================================================
