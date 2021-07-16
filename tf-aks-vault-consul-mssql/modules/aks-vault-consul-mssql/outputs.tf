output "kubeconfig" {
  value = azurerm_kubernetes_cluster.test-aks.kube_config
}

output "vault-url"{
  value = "http://${data.kubernetes_service.vault-ui.status.0.load_balancer.0.ingress.0.ip}:8200"
}

output "consul-url"{
  value = "http://${data.kubernetes_service.consul-consul-ui.status.0.load_balancer.0.ingress.0.ip}:80"
}
