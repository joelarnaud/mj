Détail complet d'utilisation
============================

  Ce module installe `jaeger`_ dans le cluster kubernetes, par défaut dans le namespace observability.

  Ce module crée les ressources suivantes :
    - namespace pour héberger jaeger (par défaut : observability)
    - installation du helm chart jaeger all in one
    - un agent jaeger
    - un collecteur jaeger
    - Une BD cassandara
    - Un UI jaeger

Ci dessous un schéma de l'infrastructure déployée :

.. image:: https://www.jaegertracing.io/img/architecture-v1.png

.. _jaeger: https://www.jaegertracing.io/



Configuration applicative
-------------------------

Pour que les applications rapportent leurs traces à Jaeger, il faut  :
  - Ajouter une librairie aux projets (ex, pour java : opentracing-spring-jaeger-cloud-starter).
  - Activer le module via configuration

.. code-block:: yaml
        :caption: Module scs_jaeger_config
        :name: Module scs_jaeger_config

          opentracing.jaeger.service-name=uberjar2k8s
          opentracing.jaeger.enabled=TRUE
          opentracing.jaeger.udp-sender.host=jaeger-agent


La configuration est en exemple dans le projet référence `uberjar2k8s <https://git.ssqti.ca/projects/PR/repos/uberjar2k8s/browse>`_ et son `playbook <https://git.ssqti.ca/projects/ANS/repos/apps-config/browse/roles/apps-springboot/templates/uberjar2k8s-application.properties.j2>`_ pour la config.
