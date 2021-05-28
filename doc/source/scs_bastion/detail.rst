Détail complet d'utilisation
============================

Une instance de type EC2 est créée avec des accès réseau aux divers services dans le VPC de chacun des comptes.
Un "security group" est attaché à cette instance qui ne permet que l'accès en SSH via le réseau local de SSQ.

L'instance utilise un golden-AMI SSQ, c'est-à-dire une image qui contient les modifications que SSQ applique
à ses serveurs linux. Les droits d'accès sont par la suite ajoutés pour produire un AMI qui est personnalisé.

Un instance profile est attaché à l'instance qui lui donne le droit d'interagir avec le
cluster EKS de scs-corpo-dev.

L'instance EC2 bastion possède aussi un stockage de type `EBS <https://aws.amazon.com/fr/ebs/>`_ sur "/" de type gp2.
Ce stockage est chiffré par une clé KMS générée par le module.

L'image est par la suite MAJ périodiquement pour incorporer les MAJ de sécurité et les modifications apportées.

On peut se connecter sur le bastion par `l'AWS CLIv2`_ ou le System Manager de la console web.

.. _l'AWS CLIv2: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html

Pour construire une nouvelle AMI manuellement, se référer au pipeline approprié dépendemment de l'usage:

* `Lab/Dev <https://jenkins.ssqti.ca/job/Deploiement_Infra/job/packer-ami/job/develop/>`_
* `Prod <https://jenkins.ssqti.ca/view/PROD/job/Prod/view/Infra/job/infra_prod_deploy/job/packer-ami/job/develop/>`_

Ajouter manuellement un bastion dans l'AD
=========================================

Ceci est une manipulation manuelle à faire pour l'instant.
Pour ajouter un bastion dans l'AD, un utilisateur avec les droits de rouler des job ansibles dans jenkins doit rouler
le `pipeline d'ajout d'un hôte EC2 dans l'AD <https://jenkins.ssqti.ca/view/%C2%A0Admin/view/Ansible/view/Provisioning/job/Ansible/job/ansible_provisioning_awsEc2JoinAD/>`_

Ce pipeline fait deux actions: elle ajoute le serveur dans satellite et ensuite dans l'AD.

Le pipeline demande un paramètre et il s'agit du host bastion à ajouter. Ex: scs_aws_corpo_dev_ec2_bastion