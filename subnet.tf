resource "azurerm_subnet" "worker" {
  name                                          = "SubnetWorker"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.worker.name
  address_prefixes                              = [var.worker_subnet_cidr]
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "standalone_bastion" {
  name                                          = "SubnetBation"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.worker.name
  address_prefixes                              = [var.standalone_bastion_cidr]
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "target" {
  name                                          = "SubnetTarget"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.target.name
  address_prefixes                              = [var.target_subnet_cidr]
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}
