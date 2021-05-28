Détail complet d'utilisation
============================

Deux instances de type EC2 sont créées avec une installation non configurée de prometheus.

L'instance utilise un golden-AMI SSQ, c'est-à-dire une image qui contient les modifications que SSQ applique
à ses serveurs linux. Les droits d'accès sont par la suite ajoutés pour produire un AMI qui est personnalisé.
L'image est par la suite MAJ périodiquement pour incorporer les MAJ de sécurité et les modifications apportées.

Cette instance devra recevoir les configurations spécifiques pour son utilisation via Ansible.

Chaque instance fait du polling directement, on utilise cependant un ELB qui lui communique avec
prometheus proxy afin de faire le PromQL. La query est effectuée sur les 2 instances, les informations sont
combinées et dé-dupliquées.

Chaque instance possède son entrée DNS ainsi qu'un Alias pour l'ELB.

Si l'instance doit monitorer un cluster kubernetes, il faut autoriser prometheus à scraper en ajustant
le security group des workers EKS (via la variable eks_worker_security_group_id).

Pour construire une nouvelle AMI manuellement, se référer au pipeline approprié dépendemment de l'usage:

* `Lab/Dev <https://jenkins.ssqti.ca/job/Deploiement_Infra/job/packer-ami/job/develop/>`_
* `Prod <https://jenkins.ssqti.ca/view/PROD/job/Prod/view/Infra/job/infra_prod_deploy/job/packer-ami/job/develop/>`_

Configuration prometheus post-déploiement
==========================================

Ceci est une manipulation manuelle à faire pour l'instant.

Pour configurer les instances prometheus, rouler le `pipeline de déploiement des configuration prometheus <https://jenkins.ssqti.ca/view/PROD/job/Prod/view/Infra/job/infra_prod_deployConfigPrometheusAWS/>`_.

Le pipeline demandera deux variables; le workload et l'environnement.

On a ajoute un disk persistent `EBS <https://aws.amazon.com/en/ebs/>`_ pour la TSDB de prometheus