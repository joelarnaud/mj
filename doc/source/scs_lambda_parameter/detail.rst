Détail complet d'utilisation
==============================

La Lambda utilisée dans ce moule vérifie l'ensemble des parameters utilisés dans SSM et vérifie leur type afin de s'assurer qu'ils sont bien de type SecureString.
En cas de présence de paramètres d'un autre type, un incident est créé dans Security Hub.

Ce module créé 4 composants :
  - Un role nommé "scs\_lambda\_parameter\_role" avec ses policies qui permet à Lambda d'écrire des logs dans Cloudwatch, de créer un incident dans SecurityHub et de consulter les parameters.
  - Un cloudwatch event nommé "scs\_check\_parameter\_compliance" et une target vers Lambda nommée "scs\_check\_parameter\_target" pour déclencher à toutes les nuits la Lambda de vérification.
  - Une Lambda bien sûr, chargée de faire la vérification. Cette Lambda est nommée "scs\_lambda\_parameter". Le code source est à la racine du module dans un fichier Zip.

Une variable nommée "schedule" est utilisée pour spécifier la planification à laquelle la Lambda sera lancée.
Une deuxième variab;e nommée scs_lambda_version permet de préciser la version de Lambda à utiliser dans le dépôt Nexus.