Détail complet d'utilisation
============================

Ce module installe un ingress `istio`_ dans le cluster kubernetes, il permet d'appeler le mesh de l'extérieur.

Ce module crée les ressources suivantes :
  - installation du helm chart istio-ingress

Le Helm chart va déclencher le provisionnement d'un `Network Load Balancer`_, qui sera bindé sur les ports du service istio-ingress déployé par le chart.
Les annotations au niveau du service istio-ingress permettent de piloter la configuration du `Network Load Balancer`_

.. _istio: https://istio.io/
.. _Network Load Balancer: https://aws.amazon.com/fr/elasticloadbalancing/network-load-balancer/
