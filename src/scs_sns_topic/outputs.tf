output "sns_arn" {
  description = "ARN of the created SNS"
  value       = aws_sns_topic.scs_aws_sns-topic.arn
}

output "sns_name" {
  description = "Name of the created SNS"
  value       = aws_sns_topic.scs_aws_sns-topic.name
}