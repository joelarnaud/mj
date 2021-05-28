output "namespace_name" {
  description = "The namespace where jaeger is installed"
  value       = kubernetes_namespace.scs_jaeger_ns.metadata[0].name
}
