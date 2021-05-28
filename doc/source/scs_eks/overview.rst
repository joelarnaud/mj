Utilisation de base
===================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_eks
        :name: Module scs_eks

            # fetch current aws account number
            data "aws_caller_identity" "scs_current_identity" {}

            module "scs_eks_dev" {
                source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_eks"

                scs_workload = "corpo"
                scs_environment = "dev"
                cluster_number = "001"

                node_termination_handler_version = "0.7.3"

                global_tags = var.global_tags
                map_roles = var.map_roles
                map_users = var.map_users
                scs_aws_authenticator_assumed_role_arn = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs-lab-admin"
                scs_vpc_id = module.scs_vpc.vpc_id
                scs_vpc_private_subnets = module.scs_vpc.private_subnets
                scs_private_access_cidr = ["172.27.0.0/16","10.0.0.0/8"]
                allowed_security_group_ids = []
                worker_groups_instances = [
                    {
                        instance_type = "t3.medium"
                        kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=normal"
                        spot_price = ""
                    },
                    {
                        instance_type = "t3.small"
                        kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot"
                        spot_price = 0.20
                    },
                    {
                        instance_type = "t3.small"
                        kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot"
                        spot_price = 0.15
                    }
                ]
                depends_on = [module.scs_vpc]
            }

.. code-block:: bash
        :caption: Ajout au provider.tf
        :name: Ajout au provider.tf

            #######
            # K8S #
            #######

            data "aws_eks_cluster" "cluster" {
              name = module.scs_eks_lab_dev.cluster_id
            }

            data "aws_eks_cluster_auth" "cluster" {
              name = module.scs_eks_lab_dev.cluster_id
            }

            provider "kubernetes" {
              host                   = data.aws_eks_cluster.cluster.endpoint
              cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
              token                  = data.aws_eks_cluster_auth.cluster.token
              load_config_file       = false
              version                = "1.13.3"
            }

            provider "helm" {
                version = "2.0.2"
                kubernetes {
                host                   = data.aws_eks_cluster.cluster.endpoint
                cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
                token                  = data.aws_eks_cluster_auth.cluster.token
              }
            }

.. code-block:: bash
        :caption: Ajout au variables.tf
        :name: Ajout au variables.tf

            ##########################
            # K8S RBAC ROLES MAPPING #
            ##########################

            variable "map_roles" {
              description = "Additional IAM roles to add to the aws-auth configmap."
              type = list(object({
                rolearn  = string
                username = string
                groups   = list(string)
              }))

              default = [
                {
                  rolearn  = "arn:aws:iam::821957301576:role/scs-lab-admin"
                  username = "scs-lab-admin"
                  groups   = ["system:masters"]
                },
                {
                  rolearn  = "arn:aws:iam::821957301576:role/EKS-ADMIN"
                  username = "scs-eks-admin"
                  groups   = ["system:masters"]
                },
                {
                  rolearn  = "arn:aws:iam::821957301576:role/K8S-MANAGER"
                  username = "scs-k8s-manager"
                  groups   = ["system:masters"]
                },
                {
                  rolearn  = "arn:aws:iam::821957301576:role/scs-bastion-ec2-eks-read-k8s-manager"
                  username = "scs-bastion-ec2-k8s-manager"
                  groups   = ["system:masters"]
                }
              ]
            }

            variable "map_users" {
              description = "Additional IAM users to add to the aws-auth configmap."
              type = list(object({
                userarn  = string
                username = string
                groups   = list(string)
              }))

              default = [
                {
                  userarn  = "arn:aws:iam::685683851314:user/scs_jenkins_dev"
                  username = "scs_jenkins_dev"
                  groups   = ["system:masters"]
                }
              ]
            }

.. code-block:: bash
        :caption: Modification au vpc.tf
        :name: Modification au vpc.tf

            private_subnet_tags = {
              "kubernetes.io/role/internal-elb" = "1", "kubernetes.io/cluster/scs-aws-lab-lab-002" = "shared"
            }

            public_subnet_tags = {
              "kubernetes.io/role/elb" = "1", "kubernetes.io/cluster/scs-aws-lab-lab-002" = "shared"
            }

Providers :
-----------

============  ===============
Name          Version 
============  ===============
aws           3.16.6
kubernetes    1.13.3
helm          1.22
============  ===============

Inputs :
--------

=========================================== ==========================================================================================================================  ==============  ===============================================================================================================
Name                                        Description                                                                                                                 Type            Default
=========================================== ==========================================================================================================================  ==============  ===============================================================================================================
scs\_workload                               The workload name to use for every intenal ressource. Ex : corpo, ag, ac ...                                                `string`        n/a
scs\_environment                            The workload environment to use for every intenal ressource. Ex : dev, pro, lab                                             `string`        n/a
cluster\_number                             Number of the cluster                                                                                                       `string`
global\_tags                                Generic tags for resources                                                                                                  `map`
map\_roles                                  Additional IAM roles to add to the aws-auth configmap.                                                                      `list`          {rolearn = string, username = string, groups   = list(string)}
map\_users                                  Additional IAM users to add to the aws-auth configmap.                                                                      `list`          {userarn = string, username = string, groups   = list(string)}
scs\_aws\_authenticator\_assumed\_role\_arn ARN of the role assumed by the aws authenticator                                                                            `string`
scs\_vpc\_id                                ID of the VPC                                                                                                               `string`
scs\_vpc\_private\_subnets                  List of the VPC private subnets                                                                                             `list(string)`
scs\_private\_access\_cidr                  List of ip CIDR allowed to connect to the K8S API                                                                           `list(string)`
allowed\_security\_group\_ids               Security Groups IDs to add to the worker nodes.                                                                             `list`
cluster\_version                            Kubernetes version to use for the EKS cluster.                                                                              `string`        1.15
worker\_ami\_name\_filter                   Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used.   `string`        amazon-eks-node-1.15-v20200228
worker\_groups\_instances                   The list of instance to be created                                                                                          `list(object)`
node\_termination\_handler\_version         Version of node termination handler helm chart                                                                              `string`        0.7.3
external\_dns\_version                      Version of external-dns container image                                                                                     `string`        v0.7.0
istio\_enabled                              Flag to enable istio in cluster                                                                                             `boolean`       false
istio\_namespace                            Namespace where istio is installed                                                                                          `string`        istio-system
=========================================== ==========================================================================================================================  ==============  ===============================================================================================================

Particularités du worker_groups_instance :
------------------------------------------

========================================  ==================================================================================================================================================================
Name                                      Description
========================================  ==================================================================================================================================================================
instance\_type                            Le type d'instance à utiliser (p.e. t3.medium)
kubelet\_extra\_arg                       Pour créer une spot instance spécifier --node-labels=kubernetes.io/lifecycle=spot, sinon fournir une chaîne vide
spot\_price                               Le prix à payer pour les spots instances. Mettre null pour une instance regulière
========================================  ==================================================================================================================================================================

Outputs :
----------

========================================  ==================================================================================================================================================================
Name                                      Description 
========================================  ==================================================================================================================================================================
iam\_policy\_aws\_alb\_ingress\_arn       The arn for the alb ingress
cluster\_certificate\_authority\_data     Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster.
cluster\_endpoint                         The endpoint for your EKS Kubernetes API.
cluster\_id                               The ID of the EKS cluster
cluster\_name                             The name of the EKS cluster
worker\_security\_group\_id               EKS Worker security group id
namespace\_name                           Kubernetes namespace where istio installed
istio\_ingress\_controller\_role\_arn     ARN of the role created in order to handle network load balancer provisionning
========================================  ==================================================================================================================================================================
