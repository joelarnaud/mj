Configurations
##############

VPC
***

    .. NOTE:: Le VPC défini un ensemble de service AWS regroupé selon la gestion de compte choisi chez SSQ.

    **Nom de ressource**

        * La nomenclature de la ressource VPC est définie selon le standard défini.

            * scs_aws_vpc_dev_001
            * scs_aws_vpc_pro_001

        * Le nom du *VPC* est aussi utilisé comme nom de module pour ce dernier

    **cidr_block**

        * Défini la plage réseau pour ce VPC
        * Le sous-réseau 10.131.0.0/16 pour le palier de DEV a été défini.
        * Le sous-réseau 10.130.0.0/16 pour le palier de PRO a été défini.

    **Subnets**

        .. NOTE:: Les subnets sont divisés en "availability zones" dans la région. Les zones sont des endroits différents dans une région ce qui permet la robustesse en cas de non-disonibilité d'une zone.

        Chaque zone contient deux subnets; un privé et un public. Les subnets publics ont un accès vers la passerelle internet (igw) et ont besoin d'une IP publique pour accéder à l'Internet. Les subnets privés n'ont que des adresses privées et ne peuvent accéder à internet que par l'intermédiaire d'une passerelle NAT.

        Le découpage avec des subnets privés/public permet l'implentation d'applications 2-tiers. L'application faisait face à Internet dans le subnet public et la BD dans le subnet privé.

        Les subnets intra servent aux transits de trafic interne non applicatifs.

        **Nom de ressource**

            * DEV

                * scs_aws_vpc_dev_001-public-<availability_zones>
                * scs_aws_vpc_dev_001-private-<availability_zones>
                * scs_aws_vpc_dev_001-intra-<availability_zones>

            * PRO

                * scs_aws_vpc_pro_001-public-<availability_zones>
                * scs_aws_vpc_pro_001-private-<availability_zones>
                * scs_aws_vpc_pro_001-intra-<availability_zones>


        **cidr_block**

            Les blocks d'adresses sont divisés en trois /21 par zone.

              ============= =============== ============= ===
              scs_aws_vpc_dev_001
              -----------------------------------------------
              Private       Public          Zones         Description
              ============= =============== ============= ===
              10.131.0.0/21 10.131.128.0/21 ca-central-1a
              10.131.8.0/21 10.131.136.0/21 ca-central-1b
              10.131.0.0/21 10.131.136.0/21 ca-central-1d
              ============= =============== ============= ===

              =============== ============= ===
              scs_aws_vpc_dev_001
              ---------------------------------
              Intra           Zones         Description
              =============== ============= ===
              10.131.224.0/21 ca-central-1a
              10.131.232.0/21 ca-central-1b
              10.131.240.0/21 ca-central-1d
              =============== ============= ===

              ============= =============== ============= ===
              scs_aws_vpc_001
              -----------------------------------------------
              Private       Public          Zones         Description
              ============= =============== ============= ===
              10.130.0.0/21 10.130.128.0/21 ca-central-1a
              10.130.8.0/21 10.130.136.0/21 ca-central-1b
              10.130.0.0/21 10.130.136.0/21 ca-central-1d
              ============= =============== ============= ===

              =============== ============= ===
              scs_aws_vpc_001
              ---------------------------------
              Intra           Zones         Description
              =============== ============= ===
              10.130.224.0/21 ca-central-1a
              10.130.232.0/21 ca-central-1b
              10.130.240.0/21 ca-central-1d
              =============== ============= ===

    **Module VPC**

        .. NOTE:: La configuration des VPC est fait par un module officiel de Terraform.   (`terraform-aws-vpc <https://github.com/terraform-aws-modules/terraform-aws-vpc>`_)

        * azs

            * Liste des Availability Zones (azs) que nous voulons utlisé dans la région.

        * private_subnets

            * Liste des subnets privés à créers, la création dans les zones est fait selon la position dans la liste azs

        * public_subnets

            * Liste des subnets public à créers, la création dans les zones est fait selon la position dans la liste azs

        * private_subnet_suffix

            * Suffix utilisé pour la création des nom des subnets privés selon cette structure: scs_aws_vpc_[dev|pro]_[Numéro]-**private**-[azs].

        * public_subnet_suffix

            * Suffix utilisé pour la création des nom des subnets public selon cette structure: scs_aws_vpc_[dev|pro]_[Numéro]-**public**-[azs].

        * enable_nat_gateway

            * Activé (true), permet la création d'une passerelle pour que les subnets privé est un accès internet et pour l'accès des workers nodes au control plane EKS

        * single_nat_gateway

            * Désactivé (false), si activé permet la création d'une seule NAT gateway, mais nous allons créer une par subnet.

        * one_nat_gateway_per_az

            * Désactivé (false), si activé permet la création d'une NAT gateway par avalability zone, mais nous allons créer une par subnet.

        * enable_vpn_gateway

            * Désactivé pour le moment, mais permettra la création du passerelle VPN pour la connexion avec le réseau SSQ.

Transit Gateway
***************
La transit gateway permet de connecter des VPC d'une région entre eux. Elle peut être partagée entre les comptes à l'aide de AWS Resource Access Manager (AWS RAM).
La transit Gateway est créée au niveau du compte partagé (share).

    **Nom des ressources**

        * La nomenclature de la ressource Transit Gateway est nommée selon le standard défini.

            * scs_aws_tg_global_001

        * La nomenclature de la resource Resource Access Manager qui partage la Transit Gateway est nommée selon le standard défini.

            * scs_aws_resource_share_global_001

    **La création du partage de la ressource aws_ram_resource_association**

        * resource_arn

            * Nom de la ressource Amazon Resource Name (ARN) de la ressource que l'on veux partager. Dans notre cas, on passe l'ARN de la Transit Gateway scs_aws_tg_global_001.

        * resource_share_arn

            * Nom de la ressource Amazon Resource Name (ARN) de la ressource RAM que l'on veux partager. Dans notre cas, on passe l'ARN de la Transit Gateway scs_aws_tg_global_001.

    **Publication de la ressource dans d'autre compte avec la resource aws_ram_principal_association**

        * principal

            * AWS account ID du compte où l'on veux rendre disponible la ressource (Transit Gateway)

        * resource_share_arn

            * Nom de la ressource Amazon Resource Name (ARN) de la ressource RAM que l'on veux partager. Dans notre cas, on passe l'ARN de la Transit Gateway scs_aws_tg_global_001.

    **Configuration dans les comptes consommateur de la TG**

    Dans le compte qui utilisera la Transit Gateway, il faut initier une demande d'utilisation. La requête est fait avec la ressource Terraform aws_ec2_transit_gateway_vpc_attachment.

        * Demande d'association au TG.

        * transit_gateway_id

            * ID du Transit Gateway créer dans le compte share.

        * vpc_id

            * L'id du vpc que l'on veux lier aux Transit Gateway.

        * subnet_ids

            * La liste des subnet privé que l'on veux lier au Transit Gateway.

        * Acceptation de la demande dans le compte share.

VPN
***

  Dans le cas SSQ, le VPN contient deux composantes; le VPN (Site-to-Site VPN Connexions) et un Customer Gateway. Le module fait par Hashicorp
  ne répond pas à notre besoin, nous utilisons alors directement les resources aws_customer_gateway pour le Customer Gateway et scs_aws_customerGW_global_001.

    **Customer Gateway**

    * bgp_asn

        * Nous utilisons 65500 pour ne pas utiliser celui par défaut (65000) qui est utiliser dans le cadre d'un autre projet.

    * ip_address

        * Adresse IP de notre firewall 45.33.200.1

    * type

        * Le type de tunnel supporter par le client. Pour l'instant AWS ne supporte que le ipsec.1

    **Site-to-Site VPN Connexions**

        * customer_gateway_id

            * Le id du customer gateway.

        * transit_gateway_id

            * Le id du la transit gateway.

        * type

            * Puisque AWS ne supporte que le type ipsec.1, on récupère le type à partir du costumer gateway.

        * static_routes_only

            * À vrai, nous utiliserons les routes statiques.

Route53
*******

    **Zone publique**

        * type : public

        * aws_route53_zone.name
        
            * Nom de la zone délégué à AWS
        
        * aws_route53_record.allow_overwrite
        
            * Valeur par défaut : true
        
        * aws_route53_record.name
        
            * Nom de l'hôte
        
        * aws_route53_record.ttl
          
            * Combien de temps que l'entrée peut vivre en cache
        
        * aws_route53_record.type
          
            * Le type d'entrée. Dans ce cas "NS" pour "name server"
        
        * aws_route53_record.zone_id
          
            * Quel est la zone qui sera modifiée

        * aws_route53_record.records
          
            * Tableau qui définis la liste des hôtes qui composera la valeur

    **Zone privée**

        * type : private

        * aws_route53_zone.name
        
            * Nom de la zone délégué à AWS
        
        * aws_route53_zone.vpc
          
            * Identifiant de la VPC par défaut pour la zone privée.

ACM
***

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
