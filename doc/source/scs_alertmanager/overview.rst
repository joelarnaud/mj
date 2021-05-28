Utilisation de base
===================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_alertmanager
        :name: Module scs_alertmanager
                module "scs-aws-lab-alertmanager" {
                  source  = "git::http://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_alertmanager?ref=terraform-module-x.x.x"

                  vpc_id     = module.scs_vpc.vpc_id
                  ami_id     = var.ami_id
                  zone_id    = module.scs_zone_route53.aws_route53_private_zone_id
                  subnet_ids = module.scs_vpc.private_subnets

                  scs_workload    = var.scs_workload
                  scs_environment = var.scs_environment

                  endpoint_authorized_cidr  = [var.scs_internal_ssq_ips, var.scs_aov_ip]
                  cluster_authorized_cidr   = [var.scs_internal_ssq_ips]
                  dashboard_authorized_cidr = [var.scs_internal_ssq_ips, var.scs_aov_ip]
                  ssh_authorized_cidr       = [var.ansible_dev_ip, var.ansible_ip]

                  ssh_allowed_security_group_ids = [module.scs-aws-lab-bastion.security_group_id]

                  providers = {
                    aws.scs-aws-account = aws
                  }
                }


Inputs :
----------

==================================  ==========================================================================================  ==============  ===============================================================================================================
Name                                Description                                                                                 Type            Default
==================================  ==========================================================================================  ==============  ===============================================================================================================
cluster\_authorized\_cidr           CIDR authorized to connect to alertmanager peering                                          `list`          n/a
endpoint_authorized_cidr            CIDR authorized to connect to alertmanager endpoint                                         `list`          n/a
dashboard_authorized_cidr           CIDR authorized to connect to alertmanager karma dashboard                                  `list`          n/a
ssh_authorized_cidr                 CIDR authorized to connect to SSH                                                           `list`          ""
subnet\_ids                         Subnet ids where the instance will have access                                              `string`        n/a
vpc\_id                             VPC id where the instance will be created                                                   `string`        n/a
ami\_id                             AMI id of the alertmanager to be created                                                    `string`        ami-053d6b075d906cb90
ssh\_allowed\_security\_group\_ids  Additionnal security group to grant SSH access                                              `list`          n/a
zone_id                             Route 53 unique id                                                                          `string`        n/a
scs_environment                     The workload environment to use for every internal ressource. Ex : dev, pro, lab            `string`        dev
scs_workload                        The workload name to use for every internal ressource. Ex : corpo, ag, ac ..."              `string`        n/a
instance_type                       Instance type to use for EC2 alertmanager                                                   `string`        t3.small
instance_count                      How many EC2 alertmanager instance                                                          `string`        3
alertmanager_port                   Alertmanager http web port                                                                  `string`        9093
alertmanager_cluster_port           Alertmanager cluster peering port                                                           `string`        9094
dashboard_port                      Karma Alertmanager dashboard web port                                                       `string`        8080
==================================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

=========================================  =============================================================================
Name                                       Description
=========================================  =============================================================================
security\_group\_id                        Alertmanager security group id
private\_dns                               List of private DNS names assigned to the instances
private\_ip                                List of private IP addresses assigned to the instances
=========================================  =============================================================================
