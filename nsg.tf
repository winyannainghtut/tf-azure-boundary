resource "azurerm_network_security_group" "standalone_bastion" {
  name                = "NSGBation"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "standalone_bastion_ssh" {
  name                        = "SSH_Allowed_fromPublic"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.standalone_bastion.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.admin_source_cidr
  destination_address_prefix  = var.standalone_bastion_cidr
}

resource "azurerm_network_security_group" "worker" {
  name                = "NSG-Worker"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "worker_to_hcp" {
  name                         = "WorkerOutboundToBoundaryCluster"
  resource_group_name          = azurerm_resource_group.this.name
  network_security_group_name  = azurerm_network_security_group.worker.name
  priority                     = 100
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "*"
  source_port_range            = "*"
  destination_port_range       = "9202"
  source_address_prefix        = var.worker_subnet_cidr
  destination_address_prefixes = var.hcp_boundary_cidrs
}

resource "azurerm_network_security_rule" "worker_to_target" {
  name                        = "WorkerToTarget"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.worker.name
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.worker_subnet_cidr
  destination_address_prefix  = var.target_vnet_cidr
}

resource "azurerm_network_security_rule" "bastion_to_worker" {
  name                        = "BationToWorker"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.worker.name
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.standalone_bastion_cidr
  destination_address_prefix  = var.worker_subnet_cidr
}

resource "azurerm_network_security_group" "target" {
  name                = "NSG-Target"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "worker_to_target_inbound" {
  name                        = "Boundary_worker_to_Target_VM"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.target.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.worker_subnet_cidr
  destination_address_prefix  = var.target_vnet_cidr
}

resource "azurerm_subnet_network_security_group_association" "standalone_bastion" {
  subnet_id                 = azurerm_subnet.standalone_bastion.id
  network_security_group_id = azurerm_network_security_group.standalone_bastion.id
}
