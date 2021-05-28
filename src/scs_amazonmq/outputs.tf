output "id" {
  description = "The unique ID that Amazon MQ generates for the broker."
  value       = aws_mq_broker.scs_aws_amazonmq.id
}

output "arn" {
  description = "The ARN of the broker."
  value       = aws_mq_broker.scs_aws_amazonmq.arn
}
