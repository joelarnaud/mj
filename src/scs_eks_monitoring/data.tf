data "aws_elasticsearch_domain" "scs_elk" {
  domain_name = var.elk_domain
  provider = aws.scs-workload-with-elk
}