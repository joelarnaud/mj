Détail complet d'utilisation
==============================

Trois instances de type EC2 sont créées avec une installation non configurée de alertmanager.

L'instance utilise un golden-AMI SSQ, c'est-à-dire une image qui contient les modifications que SSQ applique
à ses serveurs linux. Les droits d'accès sont par la suite ajoutés pour produire un AMI qui est personnalisé.
L'image est par la suite MAJ périodiquement pour incorporer les MAJ de sécurité et les modifications apportées.

Cette instance devra recevoir les configurations spécifiques pour son utilisation via Ansible.

Les trois instances fonctionnent en cluster avec une paire de VM alertmanager on-prem. Ceci est afin de permettre
un quorum pouvant perdre multiple instances et continuer de fonctionner. Les sources d'alertage sont combinées
entre AWS et le on-prem. Ceci permet de faire des groupes d'alerte globale, de la déduplication sur l'ensemble
et avoir un canal unique et universel.

Chaque instance a sa propre entrée DNS ainsi qu'un Alias pour l'ELB.

Pour construire une nouvelle AMI manuellement, se référer au pipeline approprié dépendemment de l'usage:

* `Lab/Dev <https://jenkins.ssqti.ca/job/Deploiement_Infra/job/packer-ami/job/develop/>`_
* `Prod <https://jenkins.ssqti.ca/view/PROD/job/Prod/view/Infra/job/infra_prod_deploy/job/packer-ami/job/develop/>`_