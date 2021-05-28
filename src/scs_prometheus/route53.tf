#######################
# Register Prometheus #
#######################

# Record
resource "aws_route53_record" "scs-aws-route53-private-subnet-prometheus1" {
  name     = "prometheus-1"
  type     = "A"
  records  = [aws_instance.prometheus1.private_ip]
  zone_id  = var.zone_id
  ttl      = "3600"
}

resource "aws_route53_record" "scs-aws-route53-private-subnet-prometheus2" {
  name     = "prometheus-2"
  type     = "A"
  records  = [aws_instance.prometheus2.private_ip]
  zone_id  = var.zone_id
  ttl      = "3600"
}

# Record ALB CNAME
resource "aws_route53_record" "scs-aws-route53-private-subnet-prometheus-alb" {
  name     = "prometheus"
  type     = "A"
  zone_id  = var.zone_id

  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }
}