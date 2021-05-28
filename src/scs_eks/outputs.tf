output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.scs_aws_eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = "scs-aws-${var.scs_workload}-${var.scs_environment}-${var.cluster_number}"
  #module.scs_aws_eks.cluster_name ??
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.scs_aws_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.scs_aws_eks.cluster_certificate_authority_data
}

output "iam_policy_aws_alb_ingress_arn" {
  description = "The arn for the alb ingress"
  value       = module.iam_policy_aws_ingress_controller.arn
}

output "eks_cluster_oidc_url" {
  description = "Open ID Connector issuer URL of the EKS cluster"
  value = module.scs_aws_eks.cluster_oidc_issuer_url
}

output "worker_security_group_id" {
  description= "EKS Worker security group id"
  value = module.scs_aws_eks.worker_security_group_id
}

output "istio_namespace" {
  description = "The ID of the EKS cluster"
  value       = var.istio_namespace
}


output "istio_ingress_controller_role_arn" {
  description = "Arn of istio ingress controller"
  value       = var.istio_enabled  ? module.scs_eks_istio[0].istio_ingress_controller_role_arn : null
}