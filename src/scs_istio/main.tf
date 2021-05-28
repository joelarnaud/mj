resource "kubernetes_namespace" "scs_istio_ns" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "scs_istio_base" {
  name       = "istio-base-${var.name}"
  repository = "https://repo.ssqti.ca/repository/helm-releases/"
  chart      = "istio-base"
  version    = "1.1.0"
  namespace  = kubernetes_namespace.scs_istio_ns.metadata[0].name
}

resource "helm_release" "scs_istio_discovery" {
  name       = "istiod-${var.name}"
  repository = "https://repo.ssqti.ca/repository/helm-releases/"
  chart      = "istio-discovery"
  version    = "1.2.0"
  namespace  = kubernetes_namespace.scs_istio_ns.metadata[0].name
}


data "aws_caller_identity" "scs_current_identity" {}

data "aws_iam_policy_document" "scs_istio_ingress_controller_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${var.namespace_name}:istio-ingress"]
      variable = "${substr(var.cluster_oidc_issuer_url, 8, length(var.cluster_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(var.cluster_oidc_issuer_url, 8, length(var.cluster_oidc_issuer_url))}"]
    }
  }
}

module "iam_policy_aws_istio_ingress_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "AWS_istio_ingress_controller_${var.name}"
  path        = "/"
  description = "Needed rights for the EKS istio ingress service account"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_istio_ingress_controller.json
}

resource "aws_iam_role_policy_attachment" "scs_ingress_controller_role_for_eks_pod_001_attachement" {
  role       = aws_iam_role.scs_istio_ingress_controller_role.name
  policy_arn = module.iam_policy_aws_istio_ingress_controller.arn
}

resource "aws_iam_role" "scs_istio_ingress_controller_role" {
  name = "scs_istio_ingress_controller_role_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.scs_istio_ingress_controller_role_for_eks_pod_document.json
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_istio_ingress_controller" {
  statement {
    effect    = "Allow"
    actions   = [
      "ec2:DescribeVpcs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"
    ]
    resources = ["*"]
  }
}

