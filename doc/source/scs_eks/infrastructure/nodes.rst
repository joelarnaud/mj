Worker Nodes
************

Les working nodes sont des groupes d'instances EC2 qui reçoivent les charges de travail déclarées dans EKS.
Les groupes peuvent avoir différentes configurations et différents `labels`_.
Les groupes sont en mode autoguérison par le biais de `auto-scaling groups`_ et l'ajustement du nombre de travailleurs
requis est gérée par le service `cluster autoscaler`_.
Les spécificités de chaque groupe proviennent d'une `launch configuration`_ qui est consommée par le auto-scaling group.

Le choix de type d'instances EC2 influe sur le nombre de pods que celle-ci peut héberger.
Voir le `tableau des limites`_ du plugin aws-vpc-cni.

Service Cluster autoscaler
    Ce service surveille la charge des travailleurs et ajuste le nombre de travailleurs au besoin. Il est partagé à travers
    le cluster. Le service ne supporte pas les groupes de travailleur dispersé a travers plusieurs AZ. Il faut donc
    créer des groupes individuel à travers les AZ. La version du container doit suivre la version du cluster EKS
    ( voir la `table de correspondance`_ ). Une section `FAQ`_ dans le dépôt du service documente plusieur cas
    d'utilisations et cas de configurations. Le container de ce service a les arguments de lancement particulier suivants:

    "--v=4"
        number for the log level verbosity

    "--stderrthreshold=info"
        logs at or above this threshold go to stderr

    "--cloud-provider=aws"
        Cloud provider type

    "--skip-nodes-with-local-storage=false"
        If true cluster autoscaler will never delete nodes with pods with local storage, e.g. EmptyDir or HostPath (default true)

    "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${module.scs_aws_eks_dev_001.cluster_id}"
        One or more definition(s) of node group auto-discovery. A definition is expressed <name of discoverer>:[<key>[=<value>]].
        The `aws` and `gce` cloud providers are currently supported. AWS matches by ASG tags, e.g. `asg:tag=tagKey,anotherTagKey`.
        GCE matches by IG name prefix, and requires you to specify min and max nodes per IG,
        e.g. `mig:namePrefix=pfx,min=0,max=10` Can be used multiple times. (default [])

.. _FAQ: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md
.. _table de correspondance: https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler#releases
.. _cluster autoscaler: https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
.. _auto-scaling groups: https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html
.. _launch configuration: https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchConfiguration.html
.. _labels: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
.. _tableau des limites: https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt

Optimisation des environnements de développement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Afin d'économiser sur les frais d'exécutions des nodes hors période de travail, il est possible d'ajouter la notion
de "lifecycle" aux nodes.  Les nodes qui ne devraient pas être éteinte hors plage doivent avoir un tag de lifecycle
intitulé "essential" de cette façon :

    .. code-block:: bash

        worker_groups_instances = [
        {
            instance_type = "t3.small"
            kubelet_extra_args = "--node-labels=kubernetes.io/lifecycle=essential"
        },
        {
            instance_type = "t3.small"
            kubelet_extra_args = "--node-labels=kubernetes.io/lifecycle=spot"
            spot_price = "1.50"
        },

Ainsi les pods peuvent être placé sur ces nodes dites "essential" par le biais d'un NodeSelector au niveau de la
déclaration des déploiements k8s.

Exemple :

    .. code-block:: bash

        affinity:
        nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
        - key: "kubernetes.io/lifecycle"
        operator: "In"
        values:
        - essential

TODO : Le service offhours-scaler peut être placé dans le cluster eks pour éteindre les nodes lors des périodes
hors travail.

Mise à jour des workers nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Grâce à l'implantation du Cluster Autoscaler, la mise à jour des works nodes se fait de façon simple et efficace.
Pour faire une mise à jour, nous devons spécifier la version vers laquelle nous voulons être dans le plan terraform. 

Example :

    worker_ami_name_filter = "amazon-eks-node-1.15-v20200228"

Une fois celui-ci appliqué, l'engin Cluster Autoscaler va crée une nouvelle configuration de lancement (Launch configurations) de workers nodes avec la nouvelle version
spécifiée.

Par la suite nous devons "vider" (drain) les anciens workers nodes, c'est à dire enlever les pods situés sur le worker. Si la charge est trop grande pour les workers
toujours actifs, c'est la que l'engin Cluster Autoscaler va nous présenter un worker avec la nouvelle version.
Par la suite nous pouvons effectuer le "drain" des autres worker, l'un après l'autre.

        S'il n'y a qu'un seul worker, il est recommandé d'augmenter le minimum de worker node avant de drainer le seul worker disponible puisque personne ne pourra se connecter durant le drainage
        Ne pas oublier de remettre le minimum à un après les manipulations

    .. image:: images/autoscaling.png

    .. image:: images/asg_increase.png

    .. warning::

      Pour éviter l'interruption de charges sensible ( Jobs,Batch et etc ) il est préférable
      de faire des rollout restart sur les nouvelles nodes

Pour effectuer les restart rollout, identifier les ressources ( deployments etc ) à redémarrer
par la suite exécuter la commande suivante :

`kubectl rollout restart`_ LA_RESSOURCE


Pour effectuer la désactivation du worker :

    .. code-block:: bash

        kubectl drain --force --ignore-daemonsets --delete-local-data ip-xxxxxxx.ca-central-1.compute.internal

    .. warning::

      Après 10 à 30 minutes, les anciens workers seront supprimés du EKS automatiquement.
      Nous préférons garder la main mise sur les nouvelles versions des workers, de cette façon nous pourrons décider quand nous effectuerons la mise à jour.


ECR
^^^

L'ensemble des dépôts ECR est déployé dans le compte corpo de production. Afin de permettre l'accès aux images par les workers nodes, une policy additionnelle doit être associée au rôle des worker node.

    .. code-block:: bash
        :caption: Policy document
        :name: Policy document

          data "aws_iam_policy_document" "scs_aws_iam_policy_corpo_ecr" {
                  statement {
                        effect    = "Allow"
                        actions   = [
                                "ecr:GetAuthorizationToken",
                                "ecr:BatchCheckLayerAvailability",
                                "ecr:GetDownloadUrlForLayer",
                                "ecr:GetRepositoryPolicy",
                                "ecr:DescribeRepositories",
                                "ecr:ListImages",
                                "ecr:DescribeImages",
                                "ecr:BatchGetImage"
                        ]
                        resources = ["arn:aws:ecr:ca-central-1:${var.scs_pro_aws_account_number}:repository/*"]
                  }
          }

    .. code-block:: bash
        :caption: Policy
        :name: Policy

          module "iam_policy_corpo_ecr" {
                source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
                version = "= 2.3.0"

                name        = "AWS_CORPO_ECR"
                path        = "/"
                description = "Needed rights to access corpo ECR"

                policy = data.aws_iam_policy_document.scs_aws_iam_policy_corpo_ecr.json
          }

    .. code-block:: bash
        :caption: eks.tf
        :name: eks.tf

          module "scs_aws_eks_dev_001" {
            source       = "terraform-aws-modules/eks/aws"
            version      = "7.0"

            [..]

            workers_additional_policies = [module.iam_policy_corpo_ecr.arn]

            [...]]
          }

.. _kubectl rollout restart: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-restart-em-