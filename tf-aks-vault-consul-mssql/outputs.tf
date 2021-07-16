

output "vault-url"{
  value = module.aks-vault-consul-mssql.vault-url
}

output "consul-url"{
  value = module.aks-vault-consul-mssql.consul-url
}


output "kubeconfig"{
  value = module.aks-vault-consul-mssql.kubeconfig
}

