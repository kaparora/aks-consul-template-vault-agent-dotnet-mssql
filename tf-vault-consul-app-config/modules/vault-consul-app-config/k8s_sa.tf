resource "kubernetes_service_account" "vault-auth" {
  metadata {
    name = "vault-auth"
  }
}



resource "kubernetes_service_account" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_cluster_role_binding" "vault-auth" {
  depends_on = [
    kubernetes_service_account.vault-auth,
  ]
  metadata {
    name = "role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vault-auth"
    namespace = "default"
  }
}