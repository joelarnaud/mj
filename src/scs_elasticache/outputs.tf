output "id" {
  description = "Unique ID of the ElastiCache Replication Group."
  value       = aws_elasticache_replication_group.elasticache.id
}

# REQUIRE AWS PROVIDER VERSION >= 3.25.0
# output "arn" {
#   description = "ARN of the created ElastiCache Replication Group."
#   value       = aws_elasticache_replication_group.elasticache.arn
# }
