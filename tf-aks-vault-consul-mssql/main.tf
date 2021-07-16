module "aks-vault-consul-mssql" {
  source = "./modules/aks-vault-consul-mssql"

  prefix = var.prefix
  location = var.location
  kubernetes_client_id = var.kubernetes_client_id
  kubernetes_client_secret = var.kubernetes_client_secret
}