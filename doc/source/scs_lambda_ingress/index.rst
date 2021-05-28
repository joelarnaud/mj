Module scs_lambda_ingress
===========================

Description : Ce module a pour but d'activer une Lambda qui va être lancée en cas de changements sur les security group des instances EC2 et qui va valider que ces security group n'exposent pas en ingress à tous des ports non validés (80,443).
Dans le cas ou un security group contrevient à la règle, l'évaluation Config sera mise à jour afin de le rendre non compliant dans Config.

Modules
########
.. toctree::
   :maxdepth: 2

   Utilisation de base<overview>
   Détail complet d'utilisation<detail>

