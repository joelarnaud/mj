
Zones DNS
*********
Les zones DNS permettent de propager l'emplacement de ressources informationnelles de l'organisation aux membres internes de celle-ci ainsi qu'au grand publique.

L'annuaire est délégué à Amazon (AWS) pour les ressources et services desservis par AWS. Deux (2) zones sont ainsi configuré.

Zone publique
    La zone publique *scs.ssq.ca* est créé par le plan TerraFrom/global afin d'héberger les hôtes exposés à l'Internet. Une délégation depuis l'annuaire DNS de l'organisation afin de correctement pointer la zone publique vers les service Route53 de Amazon.
    Ainsi, les requêtes destinées aux ressources hébergés chez AWS seront correctement communiqués.
    Les configurations techniques sont documentés :doc:`ici <Configurations>`.

Zone privée
    La zone privée *corpo.scs-dev.ssq.local* est créé par le plan TerraFrom/global afin d'héberger les hôtes qui **ne sont pas** exposés à l'Internet et destinés aux membres interne à l'organisation.
    Les configurations techniques sont documentés :doc:`ici <Configurations>`.

Entrées DNS
    Lorsque disponible il est préférable de créé des entrées de type `"Alias"`_ . Sinon utiliser les type de record
    classique de Address ou Canonical Name.

.. _outbound endpoint: https://aws.amazon.com/blogs/aws/new-amazon-route-53-resolver-for-hybrid-clouds/
.. _"Alias": https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-choosing-alias-non-alias.html