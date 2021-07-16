
module "vault-consul-app-config" {
  source = "./modules/vault-consul-app-config"
  kubeconfig = var.kubeconfig
  vault-url = var.vault-url
  consul-url = var.consul-url
}