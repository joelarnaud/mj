# Schedule Lambda execution
resource "aws_cloudwatch_event_rule" "scs_aws_tg_orphans_detector" {
  name = "scs-aws-tg-orphans-detector"
  description = "Trigger the detector lambda function at fixed interval"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "scs_aws_tg_orphans_detector" {
  rule = aws_cloudwatch_event_rule.scs_aws_tg_orphans_detector.name
  arn = aws_lambda_function.tg_orphans_detector.arn
  target_id = "tg-orphans-detector"
}