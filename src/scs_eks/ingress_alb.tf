############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_ingress_controller" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs_ingress_controller_role_for_eks_pod_${var.cluster_number}"
    }
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    }
    namespace = "kube-system"
  }

  automount_service_account_token = true
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role" "scs_eks_role_ingress_controller" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    }
  }
  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }
  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_role" "scs_eks_role_ingress_controller_role" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller-role"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller-role"
      "k8s-addon" = "ingress-controller.addons.k8s.io"
      "k8s-app" = "ingress-controller"
    }
    namespace = "kube-system"
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    verbs          = ["create","get"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["ingress-controller-status"]
    verbs          = ["delete","get","update"]
  }
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_ingress_controller" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
      "k8s-addon" = "ingress-controller.addons.k8s.io"
      "k8s-app" = "ingress-controller"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_ingress_controller]
}

resource "kubernetes_role_binding" "scs_eks_role_binding_ingress_controller" {
  metadata {
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
      "k8s-addon" = "ingress-controller.addons.k8s.io"
      "k8s-app" = "ingress-controller"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller-role"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    namespace = "kube-system"
  }

  depends_on = [module.scs_aws_eks]
}

##################
# K8S Ressources #
##################
resource "kubernetes_deployment" "scs_ingress_controller_deployment"{
  metadata {
    name = "ingress-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
    }
  }

  spec{
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
        }
      }

      spec {
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-alb-ingress-controller"
          image = "docker.io/amazon/aws-alb-ingress-controller:v1.1.8"
          image_pull_policy = "Always"
          args = [
            "--ingress-class=alb",
            "--cluster-name=${module.scs_aws_eks.cluster_id}",
            "--aws-region=${data.aws_region.scs_current_region.name}",
            "--aws-api-debug=true"
          ]
        }
        automount_service_account_token = true
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-ingress-controller"
      }
    }
  }

  timeouts {
    create = "25m"
    delete = "25m"
  }

  depends_on = [module.scs_aws_eks]
}

###########
# AWS IAM #
###########
data "aws_caller_identity" "scs_current_identity" {}

data "aws_iam_policy_document" "scs_ingress_controller_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_ingress_controller.id,"/",":")}"]
      variable = "${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_ingress_controller_role_for_eks_pod_001" {
  name = "scs_ingress_controller_role_for_eks_pod_${var.cluster_number}"
  assume_role_policy = data.aws_iam_policy_document.scs_ingress_controller_role_for_eks_pod_document.json
  depends_on = [module.iam_policy_aws_ingress_controller]
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_ingress_controller" {
  statement {
    effect    = "Allow"
    actions   = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates"
    ]
    resources = ["*"]
  }
   statement {
    effect    = "Allow"
    actions   = [
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL"
    ]
    resources = ["*"]
  }
   statement {
    effect    = "Allow"
    actions   = [
      "shield:DescribeProtection",
      "shield:GetSubscriptionState",
      "shield:GetSubscriptionState",
      "shield:CreateProtection",
      "shield:DescribeSubscription",
      "shield:ListProtections"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "cognito-idp:DescribeUserPoolClient"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "tag:GetResources",
      "tag:TagResources"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "waf:GetWebACL"
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_ingress_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "AWS_ingress_controller_EKS_${var.cluster_number}"
  path        = "/"
  description = "Needed rights for the EKS cluster autoscaler"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_ingress_controller.json
}

resource "aws_iam_role_policy_attachment" "scs_ingress_controller_role_for_eks_pod_001_attachement" {
  role       = aws_iam_role.scs_ingress_controller_role_for_eks_pod_001.name
  policy_arn = module.iam_policy_aws_ingress_controller.arn
}
