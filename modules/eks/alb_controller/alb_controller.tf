
# ----------------------------------------------------------------------------------------------------------------------
#   Service Account for ALB Controller Ingress
# ----------------------------------------------------------------------------------------------------------------------

resource "kubernetes_service_account" "sa_lb_controller" {
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
    name =  var.service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.ingress_role_arn
    }
  }
}

# ------------------------------------------------------------------------------------------------------------------------
#   Deploy ALB Controller Using Helm
# ------------------------------------------------------------------------------------------------------------------------

resource "helm_release" "helm_alb_controller" {
  repository = "https://aws.github.io/eks-charts"
  name      = "aws-load-balancer-controller"
  chart     = "aws-load-balancer-controller"
  namespace = "kube-system"

  set {
    name    = "clusterName"
    value   = var.cluster_name
  }
  set {
    name    = "serviceAccount.create"
    value   = "false"
  }
  set {
    name    = "serviceAccount.name"
    value   = kubernetes_service_account.sa_lb_controller.metadata[0].name
  }

  depends_on = [kubernetes_service_account.sa_lb_controller]

}
