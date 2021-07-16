provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test-aks" {
  name     = "${var.prefix}-demo-resources"
  location = var.location
}

resource "azurerm_route_table" "test-aks" {
  name                = "${var.prefix}-routetable"
  location            = azurerm_resource_group.test-aks.location
  resource_group_name = azurerm_resource_group.test-aks.name

  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_virtual_network" "test-aks" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.test-aks.location
  resource_group_name = azurerm_resource_group.test-aks.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "test-aks" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.test-aks.name
  address_prefixes       = ["10.1.0.0/22"]
  virtual_network_name = azurerm_virtual_network.test-aks.name
}

resource "azurerm_subnet_route_table_association" "test-aks" {
  subnet_id      = azurerm_subnet.test-aks.id
  route_table_id = azurerm_route_table.test-aks.id
}

resource "azurerm_kubernetes_cluster" "test-aks" {
  name                = "${var.prefix}-demo"
  location            = azurerm_resource_group.test-aks.location
  dns_prefix          = "${var.prefix}-demo"
  resource_group_name = azurerm_resource_group.test-aks.name

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      key_data = file(var.public_ssh_key_path)
    }
  }

  default_node_pool {
    name            = "agentpool"
    node_count      = "3"
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.test-aks.id
  }

  service_principal {
    client_id     = var.kubernetes_client_id
    client_secret = var.kubernetes_client_secret
  }

  network_profile {
    network_plugin = "azure"
  }
}
