Utilisation de base
=====================

Exemples d'utilisation
----------------------

L'exemple suivant met en service un *magasin de données en mémoire* Redis actif/*de secours* composé de deux noeuds.
Les noeuds sont situés dans des zones de disponibilité différentes, formant une paire redondante.

.. code-block:: bash

        module "scs_elasticache" {
          source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_elasticache"

          cluster_name            = "purple-lion"
          vpc_id                  = module.scs_vpc.vpc_id
          subnet_ids              = module.scs_vpc.private_subnets
          allowed_security_groups = [ module.scs_eks.worker_security_group_id ]
          auth_token              = ****************
          tags                    = { Environment = "LAB", MyTagName = "ItsValue" }
        }

L'exemple suivant met en service un *magasin de données en mémoire* Redis à noeud unique. Cette configuration, moins
gourmande en ressources, peut être plus approprié pour des fins de test ou développement.

.. code-block:: bash

        module "scs_elasticache" {
          source = "git::https://git.ssqti.ca/scm/infra/terraform-modules.git//src/scs_elasticache"

          cluster_name               = "black-fox"
          node_type                  = "cache.t3.micro"
          number_cache_clusters      = 1
          automatic_failover_enabled = false
          vpc_id                     = module.scs_vpc.vpc_id
          subnet_ids                 = module.scs_vpc.private_subnets
          allowed_cidrs              = [ "172.27.72.215/32" ]
          auth_token                 = ****************
          tags                       = { Environment = "LAB", MyTagName = "ItsValue" }
        }

Inputs
------

+----------------------------+----------------------------------------------------------+--------------+-----------------+
| Name                       | Description                                              | Type         | Default         |
+============================+==========================================================+==============+=================+
| cluster_name               | Middle part of the name of the cluster. Name will be     | string       | (Required)      |
|                            | scs-aws-`CLUSTERNAME`-`CLUSTERNUMBER`. Must contain      |              |                 |
|                            | only alphanumeric characters and hyphens.                |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| cluster_number             | Last part of the name of the cluster. Name will be       | string       | 001             |
|                            | scs-aws-`CLUSTERNAME`-`CLUSTERNUMBER`. Must contain      |              |                 |
|                            | only alphanumeric characters and hyphens.                |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| engine                     | Engine to be used for the cluster. Supported:            | string       | redis           |
|                            | `redis` and `memcached`.                                 |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| engine_version             | Version number of the engine to be used. See note below. | string       | 5.0.6           |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| number_cache_clusters      | Number of cache clusters (primary and replicas) this     | string       | 2               |
|                            | replication group will have. If Multi-AZ is enabled,     |              |                 |
|                            | the value of this parameter must be at least 2.          |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| automatic_failover_enabled | Specifies whether a read-only replica will be            | string       | true            |
|                            | automatically promoted to read/write primary if the      |              |                 |
|                            | existing primary fails.                                  |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| node_type                  | Compute and memory capacity of the nodes.                | string       | cache.r5.large  |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| port                       | Port number on which nodes will accept connections.      | string       | 6379            |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| at_rest_encryption_enabled | Whether to enable encryption at rest.                    | string       | true            |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| transit_encryption_enabled | Whether to enable encryption in transit.                 | string       | true            |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| auth_token                 | The password used to access a password protected server. | string       | (Optional)      |
|                            | Can be specified only if                                 |              |                 |
|                            | `transit_encryption_enabled = true`.                     |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| vpc_id                     | VPC ID.                                                  | string       | (Required)      |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| subnet_ids                 | List of subnet IDs in which to launch the cluster.       | list(string) | (Required)      |
|                            | A mimimum of 2 if ``automatic_failover_enabled`` is      |              |                 |
|                            | ``true``.                                                |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| allowed_security_groups    | List of security-groups from which inbound               | list(string) | []              |
|                            | connections are allowed.                                 |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| allowed_cidrs              | List of CIDR blocks from which inbound                   | list(string) | []              |
|                            | connections are allowed.                                 |              |                 |
+----------------------------+----------------------------------------------------------+--------------+-----------------+
| tags                       | A map of tags to assign to the resource.                 | map(string)  | (Required)      |
+----------------------------+----------------------------------------------------------+--------------+-----------------+

.. |br| raw:: html

    <br>

.. note::
    En date du 31 janvier 2021, ``aws_elasticache_replication_group``, le *provider* terraform utilisé par ce module, ne
    supporte pas la version ``6.x`` de Redis. Le support cette version est attendu sous peu.

    Pour plus d'information, visiter: |br|
    https://github.com/hashicorp/terraform-provider-aws/issues/15625

Outputs
-------

+-------------------------+--------------------------------------------------------+--------------+
| Name                    | Description                                            | Type         |
+=========================+========================================================+==============+
| id                      | Unique ID of the ElastiCache Replication Group.        | string       |
+-------------------------+--------------------------------------------------------+--------------+
| arn                     | ARN of the created ElastiCache Replication Group.      | string       |
+-------------------------+--------------------------------------------------------+--------------+
