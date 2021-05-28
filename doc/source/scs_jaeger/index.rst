Module scs_jaeger
=================

Description : Ce module permet d'installer `jaeger`_ dans un cluster kubernetes. Il se base sur le helm chart fourni par la communauté qui installe
  - un agent jaeger
  - un collecteur jaeger
  - Une BD cassandara
  - Un UI jaeger

Cette installation est uniquement conseillée pour un environnement de développement


Modules
########
.. toctree::
   :maxdepth: 2

   Utilisation de base<overview>
   Détail complet d'utilisation<detail>

.. _jaeger: https://www.jaegertracing.io/
