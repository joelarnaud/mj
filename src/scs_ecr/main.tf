###################################
# Provider : aws corpo pro workload
################################### 
provider "aws"  { 
  alias = "scs-corpo-ecr_admin"
}

 
################
# Policy for ecr
################

data "aws_iam_policy_document" "scs_aws_iam_policy_corpo_ecr" {
  statement {
    sid = "SCS_ECR_IMAGE_PULL"
    effect    = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::127602322216:root",
        "arn:aws:iam::345154063299:root",
        "arn:aws:iam::433887757690:root",
        "arn:aws:iam::746450792372:root",
        "arn:aws:iam::732658797045:root",
        "arn:aws:iam::821957301576:root",
        "arn:aws:iam::273972941115:root",
        "arn:aws:iam::746999388794:root",
        "arn:aws:iam::445295029719:root",
        "arn:aws:iam::199778711549:root",
        "arn:aws:iam::436846244383:root"        
      ]
      type = "AWS"
    }
    actions   = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
  }
}


resource "aws_ecr_repository" "scs_ecr_repository"{
  provider  = aws.scs-corpo-ecr_admin
  name      = var.ecr_repo_name

  image_scanning_configuration {
    scan_on_push = var.image_scan
  }
}
 
resource "aws_ecr_repository_policy" "scs_ecr_repository_policy" {
  provider   = aws.scs-corpo-ecr_admin
  repository = aws_ecr_repository.scs_ecr_repository.name
  policy     = data.aws_iam_policy_document.scs_aws_iam_policy_corpo_ecr.json
}

resource "aws_ecr_lifecycle_policy" "scs_ecr_lifecycle_policy" {
  provider = aws.scs-corpo-ecr_admin
  repository = aws_ecr_repository.scs_ecr_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 7 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.days_before_deletion}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}