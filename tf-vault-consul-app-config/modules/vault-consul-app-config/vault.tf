provider "vault" {
  address = var.vault-url
  #address = "http://127.0.0.1:8200"
  token = "root"
  add_address_to_env = "true"
}
