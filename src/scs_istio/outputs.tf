output "namespace_name" {
  description = "The ID of the EKS cluster"
  value       = kubernetes_namespace.scs_istio_ns.metadata[0].name
}


output "istio_ingress_controller_role_arn" {
  description = "Arn of istio ingress controller"
  value       = aws_iam_role.scs_istio_ingress_controller_role.arn
}