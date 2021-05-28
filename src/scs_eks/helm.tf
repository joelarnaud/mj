resource "helm_release" "aws_node_termination_handler" {
  name       = "node-termination-handler"
  chart      = "https://aws.github.io/eks-charts/aws-node-termination-handler-${var.node_termination_handler_version}.tgz"
  namespace  = "kube-system"
  depends_on = [module.scs_aws_eks]
}
