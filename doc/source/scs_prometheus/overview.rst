Utilisation de base
===================

Exemple d'utilisation :
-----------------------

.. code-block:: bash
        :caption: Module scs_prometheus
        :name: Module scs_prometheus

                module "scs-aws-lab-prometheus" {
                  source  = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_prometheus?ref=terraform-module-x.x.x"

                  vpc_id     = module.scs_vpc.vpc_id
                  zone_id    = module.scs_zone_route53.aws_route53_private_zone_id
                  subnet_ids = module.scs_vpc.private_subnets

                  scs_workload    = var.scs_workload
                  scs_environment = var.scs_environment

                  endpoint_authorized_cidr = [var.scs_internal_ssq_ips, var.scs_aov_ip]
                  ssh_authorized_cidr      = [var.ansible_dev_ip, var.ansible_ip]
                  promxy_authorized_cidr   = [ip_elb ou subnet vpc]

                  # Use only in lab
                  scs_vpc_number = "your_vpc_number_here"

                  ssh_allowed_security_group_ids = [module.scs-aws-lab-bastion.security_group_id]
                }

Inputs :
----------

==================================  ==========================================================================================  ==============  ===============================================================================================================
Name                                Description                                                                                 Type            Default
==================================  ==========================================================================================  ==============  ===============================================================================================================
promxy\_authorized\_cidr            CIDR authorized to connect to prometheus proxy                                              `list`          n/a
endpoint_authorized_cidr            CIDR authorized to connect to prometheus endpoint                                           `list`          n/a
ssh_authorized_cidr                 CIDR authorized to connect to SSH                                                           `list`          ""
subnet\_ids                         Subnet ids where the instance will have access                                              `string`        n/a
vpc\_id                             VPC id where the instance will be created                                                   `string`        n/a
ami\_id                             AMI id of the prometheus to be created                                                      `string`        ami-0665b814975f0f7b6
ssh\_allowed\_security\_group\_ids  Additionnal security group to grant SSH access                                              `list`          n/a
zone_id                             Route 53 unique id                                                                          `string`        n/a
scs_environment                     The workload environment to use for every internal ressource. Ex : dev, pro, lab            `string`        dev
scs_workload                        The workload name to use for every internal ressource. Ex : corpo, ag, ac ..."              `string`        n/a
instance_type                       Instance type to use for EC2 prometheus                                                     `string`        t3.medium
prometheus_port                     Prometheus http web port                                                                    `string`        9090
blackbox_port                       Prometheus Blackbox http web port                                                           `string`        9115
pushgateway_port                    Prometheus Push Gateway http web port                                                       `string`        9091
promxy_port                         Prometheus Proxy http port                                                                  `string`        8082
disk_size                           Prometheus EBS Disk in GiB                                                                  `string`        40
prometheus1_az                      Availability Zone for Prometheus Instance 1                                                 `string`        ca-central-1a
prometheus2_az                      Availability Zone for Prometheus Instance 2                                                 `string`        ca-central-1b
eks_worker_security_group_id        EKS Worker security group id to allow prometheus to scrape metrics                          `string`        null
scs_vpc_number                      Append lb name with vpc number in LAB                                                       `string`        "002"
==================================  ==========================================================================================  ==============  ===============================================================================================================


Outputs :
----------

=========================================  =============================================================================
Name                                       Description
=========================================  =============================================================================
security\_group\_id                        Prometheus security group id
private\_dns1                              DNS name assigned to instance1
private\_dns2                              DNS name assigned to instances2
private\_ip1                               IP address assigned to instance1
private\_ip2                               IP address assigned to instance2
=========================================  =============================================================================
