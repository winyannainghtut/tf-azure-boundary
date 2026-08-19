resource "azurerm_virtual_network_peering" "worker_to_target" {
  name                         = "peering-target-to-worker"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.worker.name
  remote_virtual_network_id    = azurerm_virtual_network.target.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
resource "azurerm_virtual_network_peering" "target_to_worker" {
  name                         = "peering-worker-to-target"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.target.name
  remote_virtual_network_id    = azurerm_virtual_network.worker.id
  allow_virtual_network_access = false
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
