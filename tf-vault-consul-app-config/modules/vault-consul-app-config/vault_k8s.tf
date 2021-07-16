resource "vault_policy" "app" {
  name = "app"

  policy = <<EOT
path "database/mssql/creds/dotnet-app" {
    capabilities = ["read"]
}
EOT
}
data "kubernetes_secret" "vault-auth" {
  metadata {
    name      = kubernetes_service_account.vault-auth.default_secret_name
    namespace = "default"
  }
}


resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "https://kubernetes:443"
  kubernetes_ca_cert     = data.kubernetes_secret.vault-auth.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.vault-auth.data["token"]
  issuer                 = "api"
  disable_iss_validation = "true"
}

resource "vault_kubernetes_auth_backend_role" "myrole" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "myrole"
  bound_service_account_names      = ["app"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 86400
  token_policies                   = ["app"]
}