Détail complet d'utilisation
==============================

Le service Inspector d'AWS permet de scanner des instances pour y trouver des vulnérabilités selon différentes méthodes.
La sélection des cibles â scanner se fait via des tags.

Ce module créé 3 composants :
  - Un inspector ressource group nommé "scs\_aws\_inspector\_rg" qui va spécifier les cibles â inclure dans le scan
  - Un inspector assessment target nommé "scs\_aws\_inspector\_recorder*\_confignumber*" qui est la création du scan proprement dite avec le ressource group
  - Un inspector assessment template nommé "scs\_aws\_inspector\_assessment" qui va définir quel template de balayage utiliser pour ce scan. 
