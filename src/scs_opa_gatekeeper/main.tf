##################
# OPA GateKeeper #
##################

data "helm_repository" "gatekeeper" {
  name = "gatekeeper"
  url  = "https://open-policy-agent.github.io/gatekeeper/charts"
}

resource "helm_release" "gatekeeper" {
  name       = "gatekeeper"
  repository = data.helm_repository.gatekeeper.metadata[0].name
  chart      = "gatekeeper/gatekeeper"
}


###############
# Contraintes #
###############

# Limiter les repos source à ECR
resource "null_resource" "gatekeeper_yaml_apply" {
  provisioner "local-exec" {
    command     = "kubectl apply -f ${path.module}/constraints/deployments_constraint.yaml --kubeconfig kubeconfig"
  }
  depends_on = [helm_release.gatekeeper]
}

#############
# Templates #
#############

# Déclencheur itg1
resource "null_resource" "gatekeeper_trigger_yaml_apply" {
  provisioner "local-exec" {
    command     = "kubectl apply -f ${path.module}/templates/deploy_ecr_only_itg1.yaml --kubeconfig kubeconfig"
  }
  depends_on = [helm_release.gatekeeper]
}