Utilisation de base
=====================

Exemples d'utilisation
----------------------

L'exemple suivant met en service un *agent de message* actif/*de secours* composé de deux agents. Les agents sont situés dans des zones de disponibilité différentes, formant une paire redondante.

.. code-block:: bash

        module "scs_amazonmq" {
          source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_amazonmq"

          broker_name             = "blue-panda"
          vpc_id                  = module.scs_vpc.vpc_id
          subnet_ids              = [ module.scs_vpc.private_subnets[0], module.scs_vpc.private_subnets[1] ]
          allowed_security_groups = [ module.scs_eks.worker_security_group_id ]
          allowed_protocols       = [ "AMQP", "MQTT" ]
          tags                    = { Environment = "DEV", MyTagName = "ItsValue" }

          admin_username       = "admin"
          admin_password       = ****************
          application_username = "user"
          application_password = ****************
        }

L'exemple suivant met en service un *agent de message* à noeud unique. Cette configuration, moins gourmande en ressources, peut être plus approprié pour des fins de test ou développement.

.. code-block:: bash

        module "scs_amazonmq" {
          source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_amazonmq"

          broker_name       = "red-flamingo"
          deployment_mode   = "SINGLE_INSTANCE"
          instance_type     = "mq.t3.micro"
          vpc_id            = module.scs_vpc.vpc_id
          subnet_ids        = [ module.scs_vpc.private_subnets[0] ]
          allowed_cidrs     = [ "172.27.72.215/32" ]
          allowed_protocols = [ "AMQP", "CONSOLE", "MQTT", "STOMP", "OpenWire", "WebSocket" ]
          tags              = { Environment = "LAB", MyTagName = "ItsValue" }

          admin_username       = "admin"
          admin_password       = ****************
          application_username = "user"
          application_password = ****************
        }

Inputs
------

+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| Name                    | Description                                            | Type         | Default                 |
+=========================+========================================================+==============+=========================+
| broker_name             | Middle part of the name of the broker. Name will be    | string       | (Required)              |
|                         | scs-aws-``BROKERRNAME``-``BROKERNUMBER``. Must         |              |                         |
|                         | contain only alphanumeric characters and hyphens.      |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| broker_number           | Last part of the name of the broker. Name will be      | string       | 001                     |
|                         | scs-aws-``BROKERRNAME``-``BROKERNUMBER``. Must         |              |                         |
|                         | contain only alphanumeric characters and hyphens.      |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| deployment_mode         | The deployment mode of the broker. Supported:          | string       | ACTIVE_STANDBY_MULTI_AZ |
|                         | ``SINGLE_INSTANCE`` and ``ACTIVE_STANDBY_MULTI_AZ``.   |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| engine_type             | The type of broker engine. Currently,                  | string       | ActiveMQ                |
|                         | ``aws_mq_broker`` supports only ActiveMQ.              |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| engine_version          | The version of the broker engine.                      | string       | 5.15.0                  |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| instance_type           | The broker's instance type. Defaults to                | string       | mq.m5.large             |
|                         | ``mq.m5.large``.                                       |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| admin_username          | Username of the admin user.                            | string       | (Required)              |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| admin_password          | Password of the admin user. It must be 12 to 250       | string       | (Required)              |
|                         | characters long, at least 4 unique characters, and     |              |                         |
|                         | must not contain commas.                               |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| application_username    | Username of the application user.                      | string       | (Required)              |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| application_password    | Password of the application user. It must be 12 to     | string       | (Required)              |
|                         | 250 characters long, at least 4 unique characters,     |              |                         |
|                         | and must not contain commas.                           |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| vpc_id                  | VPC ID.                                                | string       | (Required)              |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| subnet_ids              | List of subnet IDs in which to launch the broker.      | list(string) | (Required)              |
|                         | Only 1 if deployment mode is ``SINGLE_INSTANCE``, at   |              |                         |
|                         | least 2 otherwise.                                     |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| allowed_security_groups | List of security-groups from which inbound             | list(string) | []                      |
|                         | connections are allowed.                               |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| allowed_cidrs           | List of CIDR blocks from which inbound                 | list(string) | []                      |
|                         | connections are allowed.                               |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| allowed_protocols       | List of protocols for which inbound connections        | list(string) | (Required)              |
|                         | are allowed. Supported: ``AMQP (tcp/5671)``,           |              |                         |
|                         | ``CONSOLE (tcp/8162)``, ``MQTT (tcp/8883)``,           |              |                         |
|                         | ``STOMP (tcp/61614)``, ``OpenWire (tcp/61617)``        |              |                         |
|                         | and ``WebSocket (tcp/61619)``.                         |              |                         |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+
| tags                    | A map of tags to assign to the resource.               | map(string)  | (Required)              |
+-------------------------+--------------------------------------------------------+--------------+-------------------------+

Outputs
-------

+-------------------------+--------------------------------------------------------+--------------+
| Name                    | Description                                            | Type         |
+=========================+========================================================+==============+
| id                      | The unique ID that Amazon MQ generates for the broker. | string       |
+-------------------------+--------------------------------------------------------+--------------+
| arn                     | The ARN of the broker.                                 | string       |
+-------------------------+--------------------------------------------------------+--------------+
