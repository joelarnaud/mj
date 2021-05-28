Détail complet d'utilisation
============================

Ce service crée un topic dans SNS ainsi que les roles/policies nécessaire à son utilisation.

Ce module crée 3 ressources :
  - Un topic sns
  - Une policy qui permet de publier sur le topic
  - Un role attaché à un service d'aws (ex: "es.amazonaws.com") qui permet d'utiliser la policy

  