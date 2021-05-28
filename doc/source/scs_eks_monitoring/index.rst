Module scs_eks_monitoring
=========================

Description : Ce module a pour but de mettre en place `Fluentd`_ qui transporte les logs des containers
via /dev/stdout vers un aggrégateur elasticsearch. Il mets en place aussi `kube-state-metrics`_ , `prometheus-node-exporter`_
et `metrics-server`_ qui donne des informations à propos des ressources k8s et présente aussi un endpoint prometheus pour la collecte de
statistiques.

Modules
########
.. toctree::
   :maxdepth: 2

   Utilisation de base<overview>
   Détail complet d'utilisation<detail>

.. _Fluentd: https://www.fluentd.org/
.. _kube-state-metrics: https://github.com/kubernetes/kube-state-metrics
.. _metrics-server: https://github.com/kubernetes-sigs/metrics-server
.. _prometheus-node-exporter: https://github.com/prometheus/node_exporter