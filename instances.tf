resource "azurerm_linux_virtual_machine" "standalone_bastion" {
  name                            = "bastion-host"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_D2als_v6"
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.standalone_bastion.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = trimspace(tls_private_key.standalone_bastion.public_key_openssh)
  }

  os_disk {
    name                 = "bastion-host-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = var.image_version
  }

  allow_extension_operations = true
  provision_vm_agent         = true
  patch_mode                 = "ImageDefault"
  encryption_at_host_enabled = false
  secure_boot_enabled        = false
  vtpm_enabled               = false

  boot_diagnostics {}

  tags = var.tags

  depends_on = [
    azurerm_network_interface_security_group_association.standalone_bastion,
    azurerm_subnet_network_security_group_association.standalone_bastion,
  ]
}

resource "azurerm_linux_virtual_machine" "worker" {
  name                            = "WorkerNode"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_D2als_v6"
  admin_username                  = var.admin_username
  admin_password                  = random_password.worker.result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.worker.id]

  os_disk {
    name                 = "worker-node-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = var.image_version
  }

  custom_data = var.enable_boundary_worker_bootstrap ? base64encode(templatefile("${path.module}/scripts/worker-startup.sh.tftpl", {
    cluster_id       = var.hcp_boundary_cluster_id
    public_addr      = azurerm_network_interface.worker.private_ip_address
    worker_type_tags = jsonencode(var.boundary_worker_type_tags)
  })) : null

  allow_extension_operations = true
  provision_vm_agent         = true
  patch_mode                 = "ImageDefault"
  encryption_at_host_enabled = false
  secure_boot_enabled        = false
  vtpm_enabled               = false

  boot_diagnostics {}

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.enable_boundary_worker_bootstrap || try(length(trimspace(var.hcp_boundary_cluster_id)) > 0, false)
      error_message = "hcp_boundary_cluster_id must be set when enable_boundary_worker_bootstrap is true."
    }
  }

  depends_on = [
    azurerm_network_interface_security_group_association.worker,
    azurerm_subnet_nat_gateway_association.worker,
  ]
}

resource "azurerm_linux_virtual_machine" "target" {
  name                            = "TargetVM"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_D2als_v6"
  admin_username                  = var.admin_username
  admin_password                  = random_password.target.result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.target.id]

  os_disk {
    name                 = "target-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = var.image_version
  }

  allow_extension_operations = true
  provision_vm_agent         = true
  patch_mode                 = "ImageDefault"
  encryption_at_host_enabled = false
  secure_boot_enabled        = false
  vtpm_enabled               = false

  boot_diagnostics {}

  tags = var.tags

  depends_on = [
    azurerm_network_interface_security_group_association.target,
    azurerm_virtual_network_peering.worker_to_target,
    azurerm_virtual_network_peering.target_to_worker,
  ]
}
