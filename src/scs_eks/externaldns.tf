############
# K8S RBAC #
############
resource "kubernetes_service_account" "scs_service_account_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:role/scs_external_dns_role_for_eks_pod_${var.cluster_number}"
    }
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    }
    namespace = "kube-system"
  }

  automount_service_account_token = true
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role" "scs_eks_role_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
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
  depends_on = [module.scs_aws_eks]
}

resource "kubernetes_cluster_role_binding" "scs_eks_role_binding_external_dns" {
  metadata {
    name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
      "k8s-addon" = "external-dns.addons.k8s.io"
      "k8s-app" = "external-dns"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.scs_service_account_external_dns]
}


##################
# K8S Ressources #
##################
resource "kubernetes_deployment" "scs_external_dns_deployment"{
  metadata {
    name = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
    }
  }

  spec{
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
        }
      }

      spec {
        security_context {
          fs_group = 65534
        }
        container {
          name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns-${var.cluster_number}"
          image = "registry.opensource.zalan.do/teapot/external-dns:${var.external_dns_version}"
          args = var.istio_enabled ? ["--source=service","--source=ingress", "--source=istio-gateway","--provider=aws","--policy=sync","--registry=txt","--aws-zone-type="] : ["--source=service","--source=ingress","--provider=aws","--policy=sync","--registry=txt","--aws-zone-type="]
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
        service_account_name = "scs-aws-${var.scs_workload}-${var.scs_environment}-external-dns"
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
data "aws_iam_policy_document" "scs_external_dns_role_for_eks_pod_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${replace(kubernetes_service_account.scs_service_account_external_dns.id,"/",":")}"]
      variable = "${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}:sub"
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.scs_current_identity.account_id}:oidc-provider/${substr(module.scs_aws_eks.cluster_oidc_issuer_url, 8, length(module.scs_aws_eks.cluster_oidc_issuer_url))}"]
    }
  }
}

resource "aws_iam_role" "scs_external_dns_role_for_eks_pod_001" {
  name = "scs_external_dns_role_for_eks_pod_${var.cluster_number}"

  assume_role_policy = data.aws_iam_policy_document.scs_external_dns_role_for_eks_pod_document.json

  tags = {
    tag-key = "tag-value"
  }
  depends_on = [module.iam_policy_aws_external_dns]
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

  name        = "AWS_external_dns_EKS_${var.cluster_number}"
  path        = "/"
  description = "Needed rights for the EKS cluster autoscaler"

  policy = data.aws_iam_policy_document.scs_aws_iam_policy_doc_external_dns.json
}

resource "aws_iam_role_policy_attachment" "scs_external_dns_role_for_eks_pod_001_attachement" {
  role       = aws_iam_role.scs_external_dns_role_for_eks_pod_001.name
  policy_arn = module.iam_policy_aws_external_dns.arn
}
