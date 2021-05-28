Détail complet d'utilisation
==============================

La Lambda utilisée dans ce moule vérifie l'ensemble des images stockées dans les repositories d'ECR, dès l'instant ou celles ci sont taggées et ne contiennent pas le terme SNAPSHOT, pour valider si elles contiennent des vulnérabilités critiques ou élevées.
En cas de présence de vulnérabilités de cette criticité, un incident est créé dans Security Hub.

Ce module créé 4 composants :
  - Un role nommé "scs\_lambda\_ecr_scan\_role" avec ses policies qui permet à Lambda d'écrire des logs dans Cloudwatch, de créer un incident dans SecurityHub et de consulter ECR.
  - Un cloudwatch event nommé "scs\_check\_ecr\_scan" et une target vers Lambda nommée "scs\_check\_ecr\_scan" pour déclencher à toutes les nuits la Lambda de vérification.
  - Une Lambda bien sûr, chargée de faire la vérification. Cette Lambda est nommée "scs\_lambda\_ecr_scan". Le code source est à la racine du module dans un fichier Zip.

Une variable nommée "schedule" est utilisée pour spécifier la planification à laquelle la Lambda sera lancée.
Une deuxième variable nommée scs_lambda_version permet de préciser la version de Lambda à utiliser dans le dépôt Nexus.

La lambda consommée est stockée dans le dépôt : https://git.ssqti.ca/projects/SSQSEC/repos/scs-aws-ecr-vulnerabilities-lambda/