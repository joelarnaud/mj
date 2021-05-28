Module scs_lambda_ecr_scan
===========================

Description : Ce module a pour but d'activer une Lambda qui va être lancée toutes les nuits à minuit (paramétrable) par un event Cloudwatch afin de vérifier si des images dans les repositories d'ECR contiennent des vulnérabilités élevées ou critiques. 
Dans le cas ou des vulnérabilités de ce type sont détectées, alors un incident de sévérité MEDIUM est créé dans Security Hub (pour chaque vulnérabilité).

Modules
########
.. toctree::
   :maxdepth: 2

   Utilisation de base<overview>
   Détail complet d'utilisation<detail>

