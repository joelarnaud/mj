Module scs_lambda_parameter
===========================

Description : Ce module a pour but d'activer une Lambda qui va être lancée toutes les nuits à minuit par un event Cloudwatch afin de vérifier si des parameter ont été créés dans SSM sans qu'ils soient chiffrés (format SecureString). 
Dans le cas ou un de ces paramètres non chiffré est détecté, alors un incident de sévérité MEDIUM est créé dans Security Hub.

Modules
########
.. toctree::
   :maxdepth: 2

   Utilisation de base<overview>
   Détail complet d'utilisation<detail>

