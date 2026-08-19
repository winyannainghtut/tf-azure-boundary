resource "azurerm_nat_gateway" "worker" {
  name                    = "NATBoundaryWorker"
  resource_group_name     = azurerm_resource_group.this.name
  location                = azurerm_resource_group.this.location
  sku_name                = "StandardV2"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "worker" {
  nat_gateway_id       = azurerm_nat_gateway.worker.id
  public_ip_address_id = azurerm_public_ip.nat_worker.id
}

resource "azurerm_subnet_nat_gateway_association" "worker" {
  subnet_id      = azurerm_subnet.worker.id
  nat_gateway_id = azurerm_nat_gateway.worker.id
}
