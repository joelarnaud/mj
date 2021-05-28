############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.shared_account_number}:role/scs_external_dns_pro_role_for_eks_pod_${var.scs_workload}_${var.cluster_number}"
    }
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    }
    namespace = "kube-system"
  }

  automount_service_account_token = true
  
}

resource "kubernetes_cluster_role" "scs_eks_role_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get","watch","list"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list"]
  }
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["gateways", "virtualservices"]
    verbs      = ["get","watch","list"]
  }
  
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
      "k8s-addon" = "external-dns-pro-dns.addons.k8s.io"
      "k8s-app" = "external-dns-pro-dns"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_external_dns]
}


##################
# K8S Ressources #
##################
resource "kubernetes_deployment" "scs_external_dns_deployment"{
  metadata {
    name = "external-dns-pro-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
    }
  }

  spec{
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
        }
      }

      spec {
        security_context {
          fs_group = 65534
        }
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns-${var.cluster_number}"
          image = "registry.opensource.zalan.do/teapot/external-dns:${var.external_dns_version}"
          args = ["--source=service","--source=ingress", "--source=istio-gateway", "--source=istio-virtualservice","--provider=aws","--policy=sync","--registry=txt","--aws-zone-type="]
          resources {
            limits {
              cpu = "100m"
              memory = "300Mi"
            }
            requests {
              cpu = "100m"
              memory = "300Mi"
            }
          }
          image_pull_policy = "Always"
        }
        automount_service_account_token = true
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-pro-dns"
      }
    }
  }

  timeouts {
    create = "25m"
    delete = "25m"
  }

  
}

###########
# AWS IAM #
###########
locals {
  # ca-central-1
  # via
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  eks-oidc-thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

resource "aws_iam_openid_connect_provider" "scs_openid_eks_assumable_role_provider" {
  url = var.eks_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [local.eks-oidc-thumbprint]

  provider = aws.scs-shared-admin
}

data "aws_iam_policy_document" "scs_external_dns_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_external_dns.id,"/",":")}"]
      variable = "${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.shared_account_number}:oidc-provider/${substr(var.eks_oidc_issuer_url, 8, length(var.eks_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_external_dns_role_for_eks_pod_001" {
  name = "scs_external_dns_pro_role_for_eks_pod_${var.scs_workload}_${var.cluster_number}"

  assume_role_policy = data.aws_iam_policy_document.scs_external_dns_role_for_eks_pod_document.json

  tags = {
    tag-key = "tag-value"
  }

  provider = aws.scs-shared-admin
}

data "aws_iam_policy_document" "scs_aws_iam_policy_doc_external_dns" {
  statement {
    effect    = "Allow"
    actions   = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"]
  }
}

module "iam_policy_aws_external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "= 3.4.0"

  name        = "AWS_external_dns_pro_EKS_${var.scs_workload}_${var.cluster_number}"
  path        = "/"
  description = "Needed rights for external dns in pro from ${var.scs_workload}"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_external_dns.json

  providers = {aws = aws.scs-shared-admin}
}

resource "aws_iam_role_policy_attachment" "scs_external_dns_role_for_eks_pod_001_attachement" {
  role       = aws_iam_role.scs_external_dns_role_for_eks_pod_001.name
  policy_arn = module.iam_policy_aws_external_dns.arn
  provider = aws.scs-shared-admin
}
