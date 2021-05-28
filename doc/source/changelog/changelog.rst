Changelog
=========

.. Catégories de changelog : Bug fix, New feature, Upgrade, Refactoring et Doc
.. laissez un espace avant le tiret des descriptif

3.1.0 (05-05-2021) BREAKING
---------------------------

Upgrade:
 - [ eks ] Default cluster version 1.17
 - [ eks ] Default worker nodes AMI : amazon-eks-node-1.17-v20210414
 - [ alertmanager ] Update AMI 2021-03-16 -> 2021-05-04
 - [ bastion ] Update AMI 2021-03-16 -> 2021-05-04
 - [ prometheus ] Update AMI 2021-03-16 -> 2021-05-04

Doc:
 - [ eks ] Added upgrade procedure from eks 1.16 to 1.17
 - [ eks ] Added more instructions to node upgrading procedure

New feature:
 - [ bastion ] Resizable root device
 - [ bastion ] Add k8s tools + psql client
 - [ prometheus ] Now use EBS attached volume for TSDB storage
 - [ Gold Image AMI ] Now include SSM Agent + EFS mount helper

3.0.11 (03-05-2021)
-------------------

New feature:
 - [ jaeger ] Add jaeger module to enable observability on cluster

3.0.10 (25-03-2021)
-------------------

Upgrade:
 - [ alertmanager ] Update AMI from 2020-09-29 to 2021-03-16
 - [ bastion ] Update AMI from 2020-09-29 to 2021-03-16
 - [ prometheus ] Update AMI from 2020-09-29 to 2021-03-16 

Doc:
 - [ alertmanager ] Added generic terraform-module source ref
 - [ alertmanager ] Fixed typos
 - [ alertmanager ] Updated AMI ID
 - [ alertmanager ] Added links to manually build AMIs
 - [ bastion ] Changed hard-coded version from terraform-module source ref to generic one (x.x.x)
 - [ bastion ] Fixed typos + Jenkins links
 - [ bastion ] Updated AMI ID
 - [ bastion ] Added links to manually build AMIs
 - [ prometheus ] Added generic terraform-module source ref
 - [ prometheus ] Fixed typos + Jenkins links
 - [ prometheus ] Updated AMI ID
 - [ prometheus ] Added links to manually build AMIs

3.0.9 (24-03-2021)
------------------

New feature:
 - [ eks ] Add bool parametre to install istio base module

.. warning:: aws providers version in providers.tf needs to be >= 3.32.0

Bug fix:
 - [ eks ] Fix provisionning of eks module ( 1 step - with aws provider 3.32.0 )

3.0.8 (18-03-2021)
------------------

Upgrade:
 - [ elasticache ] Update security groups
 - [ alertmanager ] Add vpc number var for multiple usage in the same account
 - [ prometheus ] Add vpc number var for multiple usage in the same account

New Feature:
 - [ zone_route53 ] Unique zone names in lab
 - [ prometheus ] Unique LB names in lab
 - [ istio ] New module for istio installation in kubernetes cluster
 - [ istio_ingress ] New module for ingress istio installation in kubernetes cluster
 - [ istio_egress ] New module for egress istio installation in kubernetes cluster

Bug fix:
 - [ eks_monitoring ] Re add service account because it's still mandatory

3.0.7 (15-02-2021)
------------------

Doc:
 - [ eks ] document kubernetes / aws provider version

Upgrade:
 - [ ecr ] : Fix policy error

3.0.6 (05-02-2021)
------------------

Upgrade:
 - [ lambda_ecr_scan ] iam module version upgrade to 3.4.0
 - [ lambda_parameter ] iam module version upgrade to 3.4.0

Broken:
 - [ ecr ] : Module is not working due to policy error

3.0.5 (05-02-2021)
------------------

New feature / Doc:
 - [ ecr ] Add a policy to cleanup untagged images
 - [ amazonmq ] Amazon Active MQ
 - [ elasticache ] Add security tokens

Upgrade:
 - [ lambda_ingress ] iam module version upgrade to 3.4.0

3.0.4 (18-01-2021)
------------------

Bug fix:
 - [ eks_monitoring ] Changed prometheus-node-exporter helm chart repo

3.0.3 (18-01-2021) BROKEN
-------------------------

EMPTY

3.0.2 (15-01-2021)
------------------

Removed feature:
 - [ prometheus ] (Transfered to terraform-cloud-master) Added iam role to allow on-prem monitoring of prometheus instances

New feature:
 - [ vpc ] WARNING! Transit gateway attachement is disabled by default. Boolean to attach to the transit gateway.
 - [ elasticache ] AWS Elasticache cluster

3.0.1 (01-12-2020)
------------------

.. warning:: aws providers version in providers.tf needs to be >= 3.1.0

Upgrade:
 - [ alertmanager ] alb to community version 5.9.0


3.0.0 (30-11-2020) BROKEN
-------------------------

.. warning:: aws providers version in providers.tf needs to be >= 3.1.0

Upgrade:
 - [ eks ] eks to community module version 13.2.1
 - [ iam ] iam to community module version 3.4.0
 - [ vpc ] vpc to community module version 2.6.4
 - [ eks_monitoring ] iam to community version 3.4.0
 - [ eks_pro_dns ] iam to community version 3.4.0
 - [ prometheus ] iam to community version 3.4.0
 - [ prometheus ] alb to community version 5.9.0
 - [ watchdog ] iam to community version 3.4.0
 - [ bastion ] security-groups to community version 3.17

2.1.11 (24-11-2020)
-------------------

New feature:
 - [ prometheus ] Added iam role to allow on-prem monitoring of prometheus instances
 - [ opa_gatekeeper ] Module OPA Gatekeeper pour permettre d'ajouter des politiques sur les actions de kubectl (Kubernetes)

Refactor:
 - [ prometheus ] main.tf fragmented into several files


2.1.10 (19-11-2020)
-------------------

Bugfix:
 - [ eks ] switch de la variable spot_price en string pour accepter une valeur vide


2.1.9 (19-11-2020)
------------------

Document update:
 - [ eks ] Ajout du fichier kube config et clarification du cluster name structure

Bugfix:
 - [ prometheus ] Ajout du security group pour que prometheus accède aux workers


2.1.8 (12-11-2020)
------------------

Bugfix:
 - [ lambda_ecr_scan ] Correction de typos dans le code du module


2.1.7 (09-11-2020)
------------------

New feature:
 - [ lambda_ecr_scan ]  Ajout d'un nouveau module lambda_ecr_scan pour tester les vulnérabilités dans ECR


2.1.6 (09-11-2020)
------------------

Bugfix:
 - [ eks_monitoring ] Fix metrics server image location


2.1.5 (03-11-2020) BROKEN
-------------------------

Bugfix:
 - [ eks_monitoring ] Fix annotation


2.1.4 (02-11-2020) BROKEN
-------------------------

Bugfix:
 - [ eks_monitoring ] Enable prometheus scrape on kube-state-metrics
 - [ eks_monitoring] Allow prom security group members to call EKS worker nodes
 - [ alertmanager ] Define UDP rule on security group

Refactor:
 - [ prometheus ] Define prometheus fixed AZ

New feature:
 - [ prometheus ] use EBS for TSDB persistant storage
 - [ eks ] Add module output for worker nodes security group id

Upgrade:
 - [eks_monitoring] kube-state-metrics to 1.9.7
 - [eks_monitoring] metrics-server to 0.3.7

2.1.3 (23-10-2020)
------------------

Bugfix :
 - [ bastion ] Remove SSH keypair


2.1.2 (23-10-2020) BROKEN
-------------------------

Refactor :
 - [doc] New schema for scs_eks_pro_dns module
 - [ alertmanager ] Define default AMI ID
 - [ prometheus ] Define default AMI ID
 - [ bastion ] Define default AMI ID


2.1.1 (22-10-2020)
------------------

New feature :
 - [ eks_pro_dns ] external-dns module to add entrys in shared account zones

Refactor :
 - [ doc ] Upgrade path EKS 1.15 to 1.16


2.1.0 (21-10-2020) BREAKING
---------------------------

New feature :
 - [ eks ] EKS 1.16 / Worker nodes 1.16
 - [ doc ] Upgrade path EKS 1.15 to 1.16


2.0.13 (20-10-2020)
-------------------

Refactor :
 - Use Nexus repo for security lambda

New feature :
 - New module scs_watchdog

Bugfix:
 - [ alertmanager ] Allow UDP/TCP for cluster peering


2.0.12 (30-09-2020)
-------------------

New feature / Doc:
 - [ lambda ] Ajout d'un nouveau module lambda_parameter pour tester les parameters dans SSM
 - [ lambda ] Ajout d'un nouveau module lambda_ingress pour valider les règles en ingress des security group via Config
 - [ eks ] calico
 - New module scs_eks_csi


2.0.11 (23-09-2020)
-------------------

Refactor:
 - Replaced key word 'prod' by 'pro'

Upgrade :
 - [ doc ] Document Prometheus: Added link to jenkins config deployement pipeline


2.0.10 (11-09-2020)
-------------------

New feature / Refactoring :
 - [ doc ] Document ALL: Replaced all instances of git.ssq.local by git.ssqti.ca
 - [ doc ] Document EKS: Instance type from t2 to t3.medium
 - [ doc ] Document Bastion: Added steps to do after making a new bastion instance
 - [ eks ] Variabiliser la version de external-dns et mettre le default value a v0.7.0
 - [ bastion ] Variabilise instance name, but keep default as "bastion"


2.0.9 (28-07-2020)
------------------

Refactor:
 - Inverse changelog version order

Bugfix:
 - [ alertmanager ] Fix typo in tagname
 - [ prometheus ] Add missing port in sg

New Feature:
 - [ alertmanager ] Add Workload tag
 - [ prometheus ] Add Workload tag
 - [ bastion ] Add Workload tag

Upgrade :
 - [ eks ] MAJ update to community module 12.2
 - [ doc ] Document EKS node lifecycle tag
 - [ doc ] Document EKS nlb support


2.0.8 (28-07-2020)
------------------

Bugfix :
 - [ eks ] Cluster role group ansible could not read inventory


2.0.7 (27-07-2020)
------------------

New Feature / Upgrade:

 - [ eks ] OpenID Thumbprint update to use Root CA thumbprint instead of client Cert
 - [ prometheus ] - Add multi-instance, Route53 DNS, ELB, security group, terraform outputs
 - [ prometheus ] Update ec2 community module to version 2.15
 - [ prometheus ] variabilise instance type
 - [ prometheus ] Update sg community module to version 3.13
 - [ prometheus ] Some tag changes
 - [ prometheus ] add load balancer
 - [ alertmanager ] - New module for alertmanager, same feature from prometheus
 - [ bastion ] Update ec2 community module to version 2.15
 - [ bastion ] Instance type from t2 to t3.medium
 - [ bastion ] Update sg community module to version 3.13
 - [ bastion ] add terraform outputs for sg, priv. DNS, priv. IP


2.0.6 (15-07-2020)
------------------

New Feature / Upgrade:
 - [ eks ] Added new kubernetes cluster role groupe ansible
 - [ eks-monitoring ] Extract attributes for Kibana when json log
 - [ vpc ] Extended AOV ip ranges scs_aov_ip (172.27.64.0/18)
 - [ eks ] OpenID Thumbprint update


2.0.5 (08-07-2020)
------------------

Upgrade:
 - [ eks ] aws-alb-ingress-controller to version 1.1.8 ( from 1.1.3 )


2.0.4 (02-07-2020)
------------------

Fix:
 - [ vpc ] Add new AOV ip ranges


2.0.3 (16-06-2020)
------------------

New Feature:
 - [ route53 ] Add ssq.ca and ssqti.ca outbound resolver rules


2.0.2 (11-06-2020)
------------------

Bugfix:
 - [ config ] Adjust roles used by config module


2.0.1 (09-06-2020)
------------------

Refactoring:
 - [ config ] Change provider master by logs to declare the S3 bucket


2.0.0 (05-06-2020)
------------------

Upgrade / New Feature:
 - [ eks ] BREAKING CHANGE IN CLUSTER AUTH
 - [ eks ] Module terraform eks v12
 - [ eks ] API End point Privé
 - [ eks ] Ajout var allow private endpoint CIDR


1.0.34 (08-05-2020)
-------------------

New Feature:
- [ inspector ] Added new variable "rules_package"


1.0.33 (06-05-2020)
-------------------

New Feature:
- [ tag ] Added new tag "scs-os"


1.0.32 (05-05-2020)
-------------------

Fix:
- [ vpc ] Association du subnet de la AZ 1d à l'attachement du transit gateway.


1.0.31 (29-04-2020)
-------------------

New Feature:
- [ inspector ] Added new module to configure inspector


1.0.30 (24-04-2020)
-------------------

New Feature:
- [ vpc ] Allow to select the AZs. Default still the same as before.


1.0.29 (24-04-2020)
-------------------

Breaking change :
- [ vpc] remouve route53

Refactoring:
- [ zone_route53 ] Extract route 53 from vpc module

New Feature:
- [ zone_route53 ] Allow multiple vpc in route


1.0.28 (1-04-2020)
------------------

Refactoring:
- [ prometheus ] change string to list var ssh security group
- [ bastion ] change string to list var ssh security group

New Feature:
- [ vpc ] add ssq.extranet resolution


1.0.27 (1-04-2020)
------------------

New Feature:
- [ prometheus ] add ami_id parameter


1.0.26 (31-03-2020)
-------------------

New Feature:
- [ vpc ] Add third availability zone (ca-central-1d)
- [ ecr ] Add image scanning feature to ecr configuration


1.0.25 (25-03-2020)
-------------------

Fix / New Feature:
- [ eks ] Fix du node-termination-handler
- [ eks_monitoring ] New Feature kube-state-metrics
- [ eks_monitoring ] New Feature prometheus-node-exporter
- [ eks_monitoring ] New Feature metrics-server
- [ prometheus ] New Feature
- +Doc


1.0.24 (16-03-2020)
-------------------

Fix :
- [ eks_monitoring ] Ajustement du nom de provider pour la résolution du nom du service elasticsearch
- [ vpc ] fix de l'association de la zone route 53 au vpc scs-shared


1.0.23 (13-03-2020) BROKEN
--------------------------

Upgrade / Doc / New Feature:
- [ eks ] Maj du cluster a 1.15
- [ eks ] Doc du changement a 1.15 cluster et workers
- [ eks_monitoring ] Doc du changement vers ELK
- [ eks_monitoring ] Changement de destination de fluentd vers ELK
- [ vpc ] Refactor de l'association de la zone route53 au vpc de scs-shared


1.0.22 (12-03-2020)
-------------------

Doc / New Feature / Refactoring :
- [ bastion ] précision de la version de key-pair
- [ vpc ] Documentation subnet group
- [ vpc ] Ajout subnet group
- [ vpc ] Refactor de plan terraform


1.0.21 (10-03-2020)
-------------------

Refactoring / Bugfix :
- [ eks_monitoring ] Refactoring du plan terraform pour FluentD
- [ config ] Correctif du provider


1.0.20 (10-03-2020)
-------------------

Bugfix:
- [ vpc ] Correction de la génération des subnet et les tables de routage
