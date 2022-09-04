
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_role" "k8s_role" {
  metadata {
    name = var.role_name
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = var.rbac_resources
    verbs      = var.rbac_verbs
  }
}

resource "kubernetes_role_binding" "example" {
  metadata {
    name = var.role_binding_name
    namespace = kubernetes_namespace.ns.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.k8s_role.metadata[0].name
  }
  subject {
    kind      = "User"
    name      = var.user_name
    api_group = "rbac.authorization.k8s.io"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

}
