Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_istio_egress
        :name: Module scs_istio_egress

             module "scs_eks_istio_egress_001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_istio_egress?ref=terraform-module-3.x.x"
             }

Inputs :
----------

=================================  ==========================================================================================  ==============  ===============================================================================================================
Name                               Description                                                                                 Type            Default
=================================  ==========================================================================================  ==============  ===============================================================================================================
name                               Custom name for istio ingress installation                                                  `string`        default
namespace_name                     Kubernetes namespace where istio ingress will be installed                                  `string`        istio-system
=================================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A