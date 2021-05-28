Détail complet d'utilisation
============================

Ce module créé une lamdba qui surveille les targets groups dans le compte aws qui
n'ont pas de target associé. Ce qui permets d'avoir un avertissement dans un channel
teams via un webhook. Par la suite via `CloudWatch`_ events, l'exécution au 6 heures
est déclenchée.

Le dépôt source de cette lambda se situe ici : `scs-aws-lb-checker-lambda`_

Ce module créé les ressources suivantes :
  - Une lambda en python 3.8
  - Une Cloudwatch event rule qui a la lambda comme target qui s'exécute au 6 heures
  - Un role IAM à qui une policy est attaché
  - Une policy qui le droits de lire les ressources de LoadBalancer EC2

Les logs l'exécution de la lambda sont envoyés dans les LOGS GROUP au nom de la lambda dans AWS `CloudWatch`_.

.. _CloudWatch: https://aws.amazon.com/fr/cloudwatch/
.. _scs-aws-lb-checker-lambda: https://git.ssqti.ca/projects/INFRA/repos/scs-aws-lb-checker-lambda
