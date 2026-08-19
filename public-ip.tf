resource "azurerm_public_ip" "nat_worker" {
  name                    = "nat-pip-worker"
  resource_group_name     = azurerm_resource_group.this.name
  location                = azurerm_resource_group.this.location
  allocation_method       = "Static"
  sku                     = "StandardV2"
  sku_tier                = "Regional"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  tags                    = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "standalone_bastion" {
  name                    = "bastion-host-ip"
  resource_group_name     = azurerm_resource_group.this.name
  location                = azurerm_resource_group.this.location
  allocation_method       = "Static"
  sku                     = "Standard"
  sku_tier                = "Regional"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  tags                    = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
