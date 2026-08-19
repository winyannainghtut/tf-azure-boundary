resource "azurerm_virtual_network" "worker" {
  name                = "vnet-worker-boundary"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.worker_vnet_cidr]
  tags                = var.tags
}

resource "azurerm_virtual_network" "target" {
  name                = "vnet-target-boundary"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.target_vnet_cidr]
  tags                = var.tags
}
