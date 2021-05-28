Détail complet d'utilisation
==============================

Ce module met en service les ressources suivantes:

* Un *agent de message* `Amazon MQ`_ for `ActiveMQ`_
* Un *groupes de sécurité* permettant l'accès à l'*agent de message*

.. note::
    En date du 28 janvier 2021, ``aws_mq_broker``, le *provider* terraform utilisé par ce module, ne supporte que
    `ActiveMQ`_. Le support de `RabbitMQ`_ est attendu sous peu.

    Pour plus d'information, visiter:
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker

.. _Amazon MQ: https://aws.amazon.com/fr/amazon-mq/
.. _ActiveMQ: https://activemq.apache.org/
.. _RabbitMQ: https://www.rabbitmq.com/
