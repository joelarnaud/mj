#######
# EKS #
#######

module "scs_aws_eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = "scs-aws-${var.scs_workload}-${var.scs_environment}-${var.cluster_number}"
  cluster_version = var.cluster_version
  subnets         = var.scs_vpc_private_subnets
  vpc_id          = var.scs_vpc_id

  cluster_create_timeout = "25m"
  cluster_delete_timeout = "25m"

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  cluster_endpoint_private_access_cidrs = var.scs_private_access_cidr
  cluster_create_endpoint_private_access_sg_rule = true

  # This sits the worker nodes version for upgrade purposes ( see the nodes part of the doc )
  worker_ami_name_filter = var.worker_ami_name_filter
  worker_ami_name_filter_windows = "*"

  worker_groups = [
  for instance in var.worker_groups_instances:
  {
    instance_type         = instance["instance_type"]
    asg_desired_capacity  = 1
    autoscaling_enabled   = true
    protect_from_scale_in = true
    tags = [{
        key                 = "Environment"
        value               = var.global_tags.Environment
        propagate_at_launch = true
      },
      {
        key                 = "scs-os"
        value               = "linux"
        propagate_at_launch = true
      },
      {
        key                 = "k8s.io/cluster-autoscaler/enabled"
        value               = "true"
        propagate_at_launch = true
      },
      {
        key                 = "k8s.io/cluster-autoscaler/${module.scs_aws_eks.cluster_id}"
        value               = "true"
        propagate_at_launch = true
      }]
    kubelet_extra_args  = instance["kubelet_extra_args"]
    spot_price = instance["spot_price"]
  }
  ]

  workers_additional_policies = [module.iam_policy_corpo_ecr.arn]

  kubeconfig_aws_authenticator_additional_args = ["-r", var.scs_aws_authenticator_assumed_role_arn]

  map_users = var.map_users
  map_roles = var.map_roles

  tags      = var.global_tags

}

data "aws_region" "scs_current_region" {
  # Fetch current region
}

##############################################################################
# FIXME                                                                      # #
# aussi bug de thumbprint dans le provider                                   #
# https://github.com/terraform-providers/terraform-provider-aws/issues/10104 #
##############################################################################
locals {
  # ca-central-1
  # via
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  eks-oidc-thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

resource "aws_iam_openid_connect_provider" "scs_openid_eks_assumable_role_provider" {
  url = module.scs_aws_eks.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [local.eks-oidc-thumbprint]
}

# Policy pour acces à l'ECR de corpo

data "aws_iam_policy_document" "scs_aws_iam_policy_corpo_ecr" {
  statement {
    effect    = "Allow"
    actions   = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage"
    ]
    resources = ["arn:aws:ecr:ca-central-1:${data.aws_caller_identity.scs_current_identity.account_id}:repository/*"]
  }
}

#######
# ECR #
#######

module "iam_policy_corpo_ecr" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "AWS_CORPO_ECR_${var.cluster_number}"
  path        = "/"
  description = "Needed rights to access corpo ECR"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_corpo_ecr.json
}


##########################
# CUSTOM SECURITY GROUPS #
##########################

resource "aws_security_group_rule" "custom" {
  count = length(var.allowed_security_group_ids) > 0 ? length(var.allowed_security_group_ids) : 0
  description              = "Allow security group member to communicate with EKS nodes."
  protocol                 = "TCP"
  security_group_id        = module.scs_aws_eks.cluster_security_group_id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}