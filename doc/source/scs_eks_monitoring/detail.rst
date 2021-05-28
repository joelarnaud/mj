Détail complet d'utilisation
============================

Ce service déploie un daemonset `fluentd`_ qui lui transporte les logs vers un aggrégateur style `ELK`_ ou `CloudWatch`_.

Il déploie aussi un service de type NodePort appelé `kube-state-metrics`_. Il expose un endpoint prometheus qui englobe
plusieurs statistiques au niveau des ressources kubernetes.

Il déploie aussi un ServiceAPI qui permet d'étendre l'API natif de K8S en ajoutant metrics.k8s. Cet API permets d'exposer
les métrique systèmes de nodes et des pods dans le cluster. ( à bonifier plus tard )

Il déploi aussi un daemonset qui formate les différentes métriques en format prometheus
et qui ensuite présenté a un endpoint prometheus.

Ce module créé les ressources suivantes :
  - Un daemonset `fluentd`_ dans le cluster EKS cible
  - Droits K8S RBAC pour lister/surveiller les namespaces et les pods
  - Un daemonset `prometheus-node-exporter`_ dans le cluster EKS cible
  - Un deployment `metrics-server`_ est déployé dans le cluster cible
  - Un service account pour prometheus-node-exporter

Endpoints Prometheus diponible :
    * `metriques prometheus node exporter`_

    Ces métriques sont disponible sur le port 9100 de chaque nodes. Pour découvrir les adresses des nodes
    il s'agit de faire la commande kubectl suivante: kubectl get nodes -o wide

    * `métriques de kube-state-metrics`_

    Ces métriques sont disponible sur deux ports. Pour voir ces 2 ports il s'agit d'executer la commande kubectl
    suivante: kubectl describe service/scs-aws-ti-dev-kubestatemetrics -n kube-system | grep NodePort

    On recoit alors le port pour http-metrics et le port pour telemetry.

Les logs sont envoyés dans les LOGS GROUP dans AWS CloudWatch.

.. _fluentd: https://www.fluentd.org/
.. _CloudWatch: https://aws.amazon.com/fr/cloudwatch/
.. _ELK: https://aws.amazon.com/fr/elasticsearch-service/
.. _metrics-server: https://github.com/kubernetes-sigs/metrics-server
.. _prometheus-node-exporter: https://github.com/prometheus/node_exporter
.. _kube-state-metrics: https://github.com/kubernetes/kube-state-metrics
.. _metriques prometheus node exporter: https://github.com/prometheus/node_exporter#enabled-by-default
.. _métriques de kube-state-metrics: https://github.com/kubernetes/kube-state-metrics/tree/master/docs#exposed-metrics