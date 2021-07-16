

output "vault-url"{
  value = var.vault-url
}

output "consul-url"{
  value = var.consul-url
}


output "app-url"{
  value = module.vault-consul-app-config
}

