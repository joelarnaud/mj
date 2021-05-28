Configurations
**************

EKS
---

Le cluster K8s a été défini comme suit :

    * Un rôle IAM est ajouté au fichier kubeconfig pour appliquer le configmap aws_auth.
    * Le nom du cluster suivra la même nomenclature que le VPC soit :

        * scs_aws_eks_dev_001
        * scs_aws_eks_pro_001

    * Le nom du *cluster* est aussi utilisé comme nom de de module pour ce dernier
    * Le nombre de workers désiré est de 3
    * Le nombre maximal est de 5
    * Le nombre minimal est de 2
    * Le endpoint de l'API est privé

Un "Deployment" nommé "scs_alb_deployment" est créé dans le namespace kube-system.
Ces containers roulent la solution `aws-alb-ingress-controller`_. Cette solution fait
le pont entre les ressources de kind ingress de EKS et celle de AWS EC2, Certificate Manager et
Route53. Par le biais d'annotations insérées dans la déclaration des ingress on peut alors
manipuler les différents paramètres des ressources AWS.

Un "Deployment" nommé "scs_external_dns" est créé dans le namespace kube-system. Il ajoute
des entrées dans une zone route53 par le biais d'annotation ajouté au yaml des ingress. Voici
un lien vers un exemple d'utilisation : `exemple`_.

Le deploiment de ressources de type "NLB" ou network load balancers se fait par le biais d'annotations
qui sont décrite dans la `documentation de kubernetes sur les aws-nlb-support`_.

Une présentation sur le fonctionnement de cette solution est disponible dans l'espace fichiers
de l'équipe Drakkar sous le dossier présentations. La solution consomme un K8S service account
nommé "dev-alb-ingress-controller" qui a les permissions nécessaires a son fonctionnement.

Ce service account est créé dans le fichier k8s_rbac.tf de l'environnement. Une IAM policy avec
les permissions nécessaire a été aussi créé afin de permettre à la solution de gérer
les ressources AWS. Le pod du déploiement de la solution a cette policy d'attaché au rôle
qu'ils assument par le biais du service account.

`Calico`_ a été installé dans le cluster par dessus le `amazon-vpc-cni-k8s`_ afin de pouvoir gérer les ressources
kubernetes de type Network Policies.

Voici l'architecture généré par le module :

    .. image:: images/scs_eks_arch.png

    Le module utilisé sous terraform est : terraform-aws-modules/eks/aws

.. _Choix d'instance: https://aws.amazon.com/ec2/instance-types/
.. _aws-alb-ingress-controller: https://github.com/kubernetes-sigs/aws-alb-ingress-controller/
.. _exemple: https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md
.. _documentation de kubernetes sur les aws-nlb-support: https://kubernetes.io/docs/concepts/services-networking/service/#aws-nlb-support
.. _Calico: https://docs.projectcalico.org/about/about-network-policy
.. _amazon-vpc-cni-k8s: https://github.com/aws/amazon-vpc-cni-k8s

ACM
---

    Configuration et définition des certificats. 

    Le module utilisé sous terraform est : terraform-aws-modules/acm/aws

        **version**

            * La version utilisée est "~>2.0"
             
        **zone_id**

            * Référence à l'identifiant (zone_id) de la zone public correspondante.
        
        **domaine_name**

            * Nom de domaine pour lequel le certificat sera émis
              
        **subject_alternative_names**

            * Liste des domaines ou sous-domaines à inclure dans le présent certificat. (*Multi-domain (SAN) Certificate*)
