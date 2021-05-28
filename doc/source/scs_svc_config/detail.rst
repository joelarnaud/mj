Détail complet d'utilisation
==============================

Le service config d'AWS permet de tracer les changements détectés sur différentes
composantes et inscrit ces changements dans un bucket S3.

Ce module créé 4 composants :
  - Un delivery Config nommé "scs\_aws\_config\_delivery*\_confignumber*" qui va spécifier ou est-ce que les états de configuration doivent être stockés (dans le bucket ci dessus)
  - Un recorder Config nommé "scs\_aws\_config\_recorder*\_confignumber*" qui va spécifier quels types de ressources AWS Config va suivre et quel delivery utiliser pour enregistrer les états
  - Une policy et un rôle nommé "scs\_aws\_role\_config*\_confignumber*" pour permettre au service Config de lire les différents états de configuration des resssources AWS et de les stocker dans le S3.
  - Une autorisation vers scs-aws-audit nommé "scs\_config\_aggregate\_authorization" pour permettre à l'aggregateur de config de audit de collecter les informations du service Config du compte

Le bucket S3, dont le nom est passé en variable, va au final comprendre l'historique complet des états de configuration des différents objets AWS utilisés et ainsi permettre de comprendre l'origine de drifts lors de l'application de scripts TF.