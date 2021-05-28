
output "aws_route53_private_zone_id" {
  description = "The private zone id for route 53"
  value       = aws_route53_zone.scs_aws_route53_private.zone_id
}
