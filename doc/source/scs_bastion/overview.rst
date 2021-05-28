Utilisation de base
===================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_bastion
        :name: Module scs_bastion

            data "aws_ami" "bastion" {
              most_recent      = true
              owners           = [var.scs_aws_ti_dev_account_number]

              filter {
                name   = "name"
                values = ["bastion-*"]
              }
            }

            module "scs-aws-lab-bastion" {
              source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_bastion?ref=terraform-module-x.x.x"

              authorized_cidr = [var.scs_internal_ssq_ips, var.scs_aov_ip]
              ami_id          = data.aws_ami.bastion.image_id
              vpc_id          = module.scs_vpc.vpc_id
              subnet_ids      = module.scs_vpc.private_subnets
              zone_id         = module.scs_zone_route53.aws_route53_private_zone_id
              scs_workload    = var.scs_workload
              scs_environment = var.scs_environment
              # remove this line if not in lab, else put your vpc number next to bastion-
              bastion_name    = "bastion-your-vpc-number"

              providers = {
                aws.scs-aws-account = aws
              }
            }

Optionnel :

- Ajouter un role EC2 Instance role au bastion pour pouvoir utiliser le role de K8S-Manager dans le cluster EKS:

.. code-block:: bash
        :caption: ajout iam.tf
        :name: ajout iam.tf

            # bastion ec2 role for eks read and k8s manager

            data "aws_iam_policy_document" "scs_bastion_allow_assume" {
              statement {
                effect  = "Allow"
                actions = ["sts:AssumeRole"]
                principals {
                  type        = "Service"
                  identifiers = ["ec2.amazonaws.com"]
                }
              }
            }

            resource "aws_iam_role" "scs_bastion_ec2_eks_read_k8s-manager" {
              name = "scs-bastion-ec2-eks-read-k8s-manager"

              assume_role_policy = data.aws_iam_policy_document.scs_bastion_allow_assume.json

              tags = {
                tag-key = "tag-value"
              }
            }

            resource "aws_iam_instance_profile" "scs-lab-bastion-profile" {
              name = "ec2-bastion-ec2-eks-read-k8s-manager"
              role = aws_iam_role.scs_bastion_ec2_eks_read_k8s-manager.name
            }

            # Bastion EC2

            data "aws_iam_policy_document" "scs_ec2_eks_read_k8s_manager" {
              statement {
                effect    = "Allow"
                actions   = [
                  "eks:ListFargateProfiles",
                  "eks:DescribeNodegroup",
                  "eks:ListNodegroups",
                  "eks:DescribeFargateProfile",
                  "eks:ListTagsForResource",
                  "eks:ListUpdates",
                  "eks:DescribeUpdate",
                  "eks:DescribeCluster",
                  "eks:ListClusters"
                ]
                resources = ["*"]
              }
            }

            resource "aws_iam_role_policy" "scs_bastion_ec2_eks_read_k8s_manager_policy" {
              name = "ec2-bastion-k8s-manager"
              role = aws_iam_role.scs_bastion_ec2_eks_read_k8s-manager.id

              policy = data.aws_iam_policy_document.scs_ec2_eks_read_k8s_manager.json
            }

            # K8s read

            data "aws_iam_policy_document" "scs_data_policy_eks_read" {
              statement {
                effect    = "Allow"
                actions   = [
                  "eks:ListClusters",
                  "eks:DescribeCluster"
                ]
                resources = ["*"]
              }
            }

            module "scs_iam_user_lab_list_resources" {
              source  = "terraform-aws-modules/iam/aws//modules/iam-user"
              version = "= 2.3.0"

              name = "scs-lab-list-resources"

              force_destroy                 = true
              create_iam_user_login_profile = false
              password_reset_required       = false
            }

            module "scs_iam_policy_lab_list_resources" {
              source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
              version = "= 2.3.0"

              name        = "LIST-EKS-RESOURCES"
              path        = "/"
              description = "List eks resources access"

              policy = data.aws_iam_policy_document.scs_data_policy_eks_read.json
            }

            module "scs_lab_list_resources" {
              source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
              version = "= 2.3.0"

              trusted_role_arns = [
                module.scs_iam_user_lab_list_resources.this_iam_user_arn
              ]

              create_role = true

              role_name         = "scs-shared-list-resources-role"
              role_requires_mfa = false
              custom_role_policy_arns = [
                module.scs_iam_policy_lab_list_resources.arn
              ]
            }

            # AWS System Manager
            resource "aws_iam_role_policy_attachment" "scs_bastion_ec2_smm_instance_core" {
              role       = aws_iam_role.scs_bastion_ec2_eks_read_k8s-manager.id
              policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
            }

Par la suite il s'agit de passer le nom de l'instance profile au module bastion par la variable iam_instance_profile :

i.e.: iam_instance_profile = aws_iam_instance_profile.scs-lab-bastion-profile.name

Une fois le bastion joint au AD SSQ, se logger dessus et simplement ajouter le contexte de configuration EKS comme ceci :

.. code-block:: bash
        :caption: Récuperation contexte EKS
        :name: Récuperation contexte EKS

            aws eks --region ca-central-1 update-kubeconfig --name scs-aws-lab-lab-002 --kubeconfig /tmp/kubeconfig

Providers :
-----------

======================================  ====================
Name                                    Version
======================================  ====================
scs-aws-account                         n/a
======================================  ====================

Inputs :
----------

============================  ==========================================================================================  ==============  ===============================================================================================================
Name                          Description                                                                                 Type            Default
============================  ==========================================================================================  ==============  ===============================================================================================================
scs_workload                  The workload name to use for every intenal ressource. Ex : corpo, ag, ac ...                `string`        n/a
scs_environment               The workload environment to use for every intenal ressource. Ex : dev, pro, lab             `string`        n/a
authorized\_cidr              CIDR authorized to connect to jump box                                                      `list`          n/a
subnet\_ids                   Subnet ids where the jumb box will have access                                              `string`        n/a
vpc\_id                       VPC id where the jumb box will be created                                                   `string`        n/a
zone\_id                      Route 53 unique id                                                                          `string`        n/a
iam\_instance\_profile        IAM EC2 profile for the instance                                                            `string`        n/a
ami\_id                       AMI id of the specific SSQ bastion release to use                                           'string'        ami-051e67f69666be8b1
bastion\_name                 Override the default "bastion" name ( i.e. : Multiple bastion in lab )                      'string'        'bastion'
volume\_size                  Size in Go of the root volume                                                               'string'        '10'
============================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

=========================================  =============================================================================
Name                                       Description
=========================================  =============================================================================
security\_group\_id                        Alertmanager security group id
private\_dns                               List of private DNS names assigned to the instances
private\_ip                                List of private IP addresses assigned to the instances
instance\_id                               EC2 Instance id
=========================================  =============================================================================