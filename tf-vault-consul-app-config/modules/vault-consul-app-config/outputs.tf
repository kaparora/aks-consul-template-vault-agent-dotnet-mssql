
output "app-url"{
  value = "http://${kubernetes_service.app.status.0.load_balancer.0.ingress.0.ip}/api/Projects"
}

