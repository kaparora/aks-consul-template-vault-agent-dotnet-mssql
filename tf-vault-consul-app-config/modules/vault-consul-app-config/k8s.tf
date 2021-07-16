provider "kubernetes" {
    host                   = var.kubeconfig.0.host
    username               = var.kubeconfig.0.username
    password               = var.kubeconfig.0.password
    client_certificate     = base64decode(var.kubeconfig.0.client_certificate)
    client_key             = base64decode(var.kubeconfig.0.client_key)
    cluster_ca_certificate = base64decode(var.kubeconfig.0.cluster_ca_certificate)
  }