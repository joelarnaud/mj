Détail complet d'utilisation
==============================

La Lambda utilisée dans ce moule vérifie toutes les règles d'un security group qui lui est passé par une règle Config custom et valide qu'il n'existe aucune de ces règles qui expose un port autre que 443 et 80 sur 0.0.0.0.
Si une règle contrevient, alors le security group est taggé comme non compliant par la Lambda dans AWS Config. 

Ce module créé 3 composants :
  - Un role nommé "scs\_lambda\_ingress\_role" avec ses policies qui permet à Lambda d'écrire des logs dans Cloudwatch ainsi que modifier un status dans AWS Config.
  - Une règle custom Config qui appel la Lambda à chaque changement dans un security group.
  - Une Lambda bien sûr, chargée de faire la vérification. Cette Lambda est nommée "scs\_lambda\_ingress". Le code source est à la racine du module dans un fichier Zip.

Une variable nommée scs_lambda_version permet de préciser la version de Lambda à utiliser dans le dépôt Nexus.