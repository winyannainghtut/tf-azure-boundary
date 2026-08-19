resource "azurerm_network_interface" "standalone_bastion" {
  name                           = "bastion-host-nic"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = false
  tags                           = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.standalone_bastion.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.standalone_bastion.id
    primary                       = true
  }
}

resource "azurerm_network_interface" "worker" {
  name                           = "worker-node-nic"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = false
  tags                           = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.worker.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true
  }
}

resource "azurerm_network_interface" "target" {
  name                           = "target-vm-nic"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = false
  tags                           = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.target.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true
  }
}

resource "azurerm_network_interface_security_group_association" "standalone_bastion" {
  network_interface_id      = azurerm_network_interface.standalone_bastion.id
  network_security_group_id = azurerm_network_security_group.standalone_bastion.id
}

resource "azurerm_network_interface_security_group_association" "worker" {
  network_interface_id      = azurerm_network_interface.worker.id
  network_security_group_id = azurerm_network_security_group.worker.id
}

resource "azurerm_network_interface_security_group_association" "target" {
  network_interface_id      = azurerm_network_interface.target.id
  network_security_group_id = azurerm_network_security_group.target.id
}
