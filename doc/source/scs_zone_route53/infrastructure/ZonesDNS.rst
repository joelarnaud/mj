
Zones DNS
*********
Les zones DNS permettent de propager l'emplacement de ressources informationnelles de l'organisation aux membres internes de celle-ci ainsi qu'au grand publique.


Résolution DNS
    Un Route53 `outbound endpoint`_ a été mis en place pour pouvoir transporter les demandes de résolutions
    provenant du VPC vers les serveur Active Directory interne de SSQ. Ceux-ci résoudrons les noms des domaines
    privés suivants : ssq.local. Le mécanisme du outbound endpoint utilise une présence dans chacun des subnets
    du VPC pour transporter par des règles les demandes de résolutions.

.. _outbound endpoint: https://aws.amazon.com/blogs/aws/new-amazon-route-53-resolver-for-hybrid-clouds/
.. _"Alias": https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-choosing-alias-non-alias.html