provider "consul" {
  address    = var.consul-url
  datacenter = "dc1"
}

resource "consul_keys" "mykey" {
  datacenter = "dc1"

  # Set the CNAME of our load balancer as a key
  key {
    path  = "hashicorp/kapil/dotnet/myId"
    value = "consul-vault-dotnet-demo"
  }
  key {
    path  = "hashicorp/kapil/dotnet/myYearOfFirstCommit"
    value = "2021"
  }
  key {
    path  = "hashicorp/kapil/dotnet/myGitHubLink"
    value = "https://github.com/kaparora"
  }
}