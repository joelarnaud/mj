###########
# SNS topic
###########
resource "aws_sns_topic" "scs_aws_sns-topic" {
  name = "scs_sns_${var.topic_name}-topic"
  display_name = "scs_sns_${var.topic_name}-topic-alert"
  delivery_policy = <<DELIVERY_POLICY
    {
    "http": {
      "defaultHealthyRetryPolicy": {
        "minDelayTarget": 20,
        "maxDelayTarget": 20,
        "numRetries": 3,
        "numMaxDelayRetries": 0,
        "numNoDelayRetries": 0,
        "numMinDelayRetries": 0,
        "backoffFunction": "linear"
      },
      "disableSubscriptionOverrides": false
    }
  }
  DELIVERY_POLICY

}


#############
# Assume role
#############

resource "aws_iam_role" "scs_sns-publish" {
  name = "scs_sns_${var.topic_name}-alert"

  assume_role_policy = data.aws_iam_policy_document.scs_sns_assume_role_policy.json
}


data "aws_iam_policy_document" "scs_sns_assume_role_policy" {
  statement {
    effect = "Allow"
    actions  = ["sts:AssumeRole"]

    principals {
      identifiers = [var.principal_service]
      type = "Service"
    }
  }
}



###############
# IAM policies
###############
resource "aws_iam_policy" "scs_sns_publish_policy" {
  name_prefix = "scs_sns_${var.topic_name}"
  policy      = data.aws_iam_policy_document.scs_sns-publish-policy-document.json
}

data "aws_iam_policy_document" "scs_sns-publish-policy-document" {
  statement {
    effect = "Allow"
    actions  = ["sns:Publish"]

    resources = [aws_sns_topic.scs_aws_sns-topic.arn]
  }
}

resource "aws_iam_role_policy_attachment" "scs_sns_publish_policy_attachment" {
  policy_arn = aws_iam_policy.scs_sns_publish_policy.arn
  role       = aws_iam_role.scs_sns-publish.name
}