Utilisation de base
=====================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_istio_ingress
        :name: Module scs_istio_ingress

             module "scs_eks_istio_ingress_001" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_istio_ingress?ref=terraform-module-3.x.x"
                internal = true
                ssl_certificate_arn = "arn:aws:acm:ca-central-1:123456789:certificate/xxxx"
                istio_ingress_controller_role_arn = module.scs_eks_istio_lab_dev.istio_ingress_controller_role_arn
             }

Inputs :
----------

=================================  ==========================================================================================  ==============  ===============================================================================================================
Name                               Description                                                                                 Type            Default
=================================  ==========================================================================================  ==============  ===============================================================================================================
internal                           Indicate if load balancer is internal or public facing                                      `boolean`       true
name                               Custom name for istio ingress installation                                                  `string`        default
namespace_name                     Kubernetes namespace where istio ingress will be installed                                  `string`        istio-system
istio_ingress_controller_role_arn  ARN of the role use by service account to provision NLB                                     `string`        N/A
negociation_policy                 TLS Policy to use by ingress                                                                `string`        ELBSecurityPolicy-TLS-1-2-2017-01
ssl_certificate_arn                certificate ARN to use for HTTPS                                                            `string`        N/A
=================================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

N/A