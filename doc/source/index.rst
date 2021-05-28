Module Terraform pour AWS
============================

Description : Ce projet présente un stencil des différents modules custom SSQ.
Afin de bien différencier les modules SSQ, le préfix **scs_** sera utilisé.

Utilisation : Lors de l'utilisation d'un module, référez-le en utilisant la source avec le format suivant : source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_vpc?ref=terraform-module-1.0.0-release"

Voici le liens vers le CHANGELOG des modules terraform : :doc:`CHANGELOG<changelog/changelog>`


=============================
Modules et versions terraform
=============================

Voici la liste des modules externes et leurs versions :

.. NOTE:: Version de `terraform`_ actuellement utilisé : 0.12.20

 * aws-eks -> version 7.0
 * aws-iam -> version 2.3.0
 * aws-vpc -> version 2.17.0
 * aws-config -> version 1.0.7
 * provider -> version 2.31.0
 * ec2-instance -> version 2.15.0
 * security-group -> version 3.13.0

Modules
#######
.. toctree::
   :maxdepth: 1

   CHANGELOG<changelog/changelog>
   scs_eks<scs_eks/index>
   scs_eks_monitoring<scs_eks_monitoring/index>
   scs_eks_csi<scs_eks_csi/index>
   scs_eks_pro_dns<scs_eks_pro_dns/index>
   scs_vpc<scs_vpc/index>
   scs_bastion<scs_bastion/index>
   scs_prometheus<scs_prometheus/index>
   scs_alertmanager<scs_alertmanager/index>
   scs_svc_config<scs_svc_config/index>
   scs_ecr<scs_ecr/index>
   scs_sns_topic<scs_sns_topic/index>
   scs_inspector<scs_inspector/index>
   scs_zone_route53<scs_zone_route53/index>
   scs_lambda_parameter<scs_lambda_parameter/index>
   scs_lambda_ingress<scs_lambda_ingress/index>
   scs_opa_gatekeeper<scs_opa_gatekeeper/index>
   scs_watchdog<scs_watchdog/index>
   scs_lambda_ecr_scan<scs_lambda_ecr_scan/index>
   scs_elasticache<scs_elasticache/index>
   scs_amazonmq<scs_amazonmq/index>
   scs_istio<scs_istio/index>
   scs_istio_ingress<scs_istio_ingress/index>
   scs_istio_egress<scs_istio_egress/index>
   scs_jaeger<scs_jaeger/index>

===============================
Normes d'infrastructure as code
===============================

    Lors de rédaction de documentation idéalement il ne faudrait pas dépasser 80 caractères sur une
    seule ligne. Ce qui facilite l'utilisation de plusieurs fenêtres d'édition et facilite la lisibilité.

    Lors de la rédaction de plans terraform il est recommandé de suivre les bonnes pratiques suivantes:

    * Utiliser des minuscules et des chiffres pour le nom d'une ressource.
    * Utiliser des _ (soulignés) pour le nom des ressources terraform.
    * Le nom des ressources doit commencer par "scs\_" pour "SSQ Cloud Services"

      ex: scs_aws_vpc_dev_001

    * Ne pas répéter le type de ressource dans le nom de la ressource.

      ex: ressource "aws_instance" "aws_instance_type1"

    * Les fichiers Terraform doivent être créés afin qu'ils soient le plus dynamique possible. Les valeurs susceptibles de changer devraient être "variabilisées" dans le fichier *variables.tf* correspondant.
    * Définir les tags de la ressource à la fin de celle-ci. (sauf pour depends_on et lifecycle)
    * Utiliser des noms au pluriel pour les variables de type `list et map`_.
    * Utiliser une majuscule pour la première lettre d'un tag.
    * Utiliser les termes anglophones des technologies décrites.
    * Utiliser le data "aws_iam_policy_document" pour construire une policy JSON.

    .. NOTE:: Il a été convenu que la norme d'indentation suivait les recommendations de HashiCorp, soit 2 espaces, pour tous les fichiers Terraform.


    .. code-block:: bash
        :caption: exemple.tf
        :name: exemple.tf

            data "aws_iam_policy_document" "depot_s3_rw" {
              statement {
                effect    = "Allow"
                actions   = ["s3:*"]
                resources = ["arn:aws:s3:::nom-du-depot"]
                principals {
                  type        = "AWS"
                  identifiers = ["arn:aws:iam::0000000000:role/S3-READWRITE"]
                }
              }
            }

.. _terraform: https://releases.hashicorp.com/terraform/
.. _list et map: https://www.terraform.io/docs/configuration/types.html#collection-types
