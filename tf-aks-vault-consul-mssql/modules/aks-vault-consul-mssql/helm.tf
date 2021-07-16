provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.test-aks.kube_config.0.host
    username               = azurerm_kubernetes_cluster.test-aks.kube_config.0.username
    password               = azurerm_kubernetes_cluster.test-aks.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
    host                   = azurerm_kubernetes_cluster.test-aks.kube_config.0.host
    username               = azurerm_kubernetes_cluster.test-aks.kube_config.0.username
    password               = azurerm_kubernetes_cluster.test-aks.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.test-aks.kube_config.0.cluster_ca_certificate)
  }

resource "helm_release" "demo-vault" {
  depends_on = [
    helm_release.demo-consul,
  ]
  name  = "vault"
  chart = "hashicorp/vault"
  version = "0.13.0"
  values = [
    "${file("${path.module}/vault-helm-values.yaml")}"
  ]
}

resource "helm_release" "demo-consul" {
  name  = "consul"
  chart = "hashicorp/consul"
  version = "0.31.0"
  values = [
    "${file("${path.module}/consul-helm-values.yaml")}"
  ]
}

data "kubernetes_service" "vault-ui" {
  depends_on = [
    helm_release.demo-vault
  ]
  metadata {
    name = "vault-ui"
  }
}

data "kubernetes_service" "consul-consul-ui" {
  depends_on = [
    helm_release.demo-consul,
  ]
  metadata {
    name = "consul-consul-ui"
  }
}
