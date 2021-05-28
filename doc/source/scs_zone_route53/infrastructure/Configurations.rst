Configurations
##############

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
