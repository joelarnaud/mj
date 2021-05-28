Détails complets d'utilisation
==============================

Ce module permets l'utilisation de Open Policy Agent Gatekeeper (`OPA Gatekeeper`_) pour implanter des politiques de
restriction d'utilisation dans un namespace Kubernetes avec l'aide de contraintes ('constraints').

Pour le moment, nous avons implanté les contraintes suivantes dans les namespaces suivants:

============================================  ==========================================================================================  ==============  
Nom                                           Description                                                                                 Namespace(s)       
============================================  ==========================================================================================  ==============  
constraints/deployments_constraint.yml        Restreindre les sources d'image de conteneurs pour ne permettre que ECR                     itg1
============================================  ==========================================================================================  ==============  



- 

Ce module créé les ressources suivantes :
  - Les contraintes mentionnées ci-haut
  - Les déclencheurs ('templates') sur lesquels la ou les contrainte(s) s'applique(nt)

.. _OPA Gatekeeper: https://www.openpolicyagent.org/docs/latest/kubernetes-introduction/#what-is-opa-gatekeeper
