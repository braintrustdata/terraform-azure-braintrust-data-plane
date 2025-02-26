resource "random_password" "clickhouse" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_network_interface" "clickhouse" {
  count               = var.clickhouse_instance_count
  name                = "nic-${var.deployment_name}-clickhouse"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_linux_virtual_machine" "clickhouse" {
  count               = var.clickhouse_instance_count
  name                = "vm-${var.deployment_name}-clickhouse"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.clickhouse_vm_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.clickhouse[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_managed_disk" "clickhouse_data" {
  count                = var.clickhouse_instance_count
  name                 = "disk-${var.deployment_name}-clickhouse-data"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.clickhouse_data_disk_size_gb

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "clickhouse_data" {
  count              = var.clickhouse_instance_count
  managed_disk_id    = azurerm_managed_disk.clickhouse_data[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.clickhouse[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_storage_account" "clickhouse" {
  name                     = "stch${var.deployment_name}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    deployment = var.deployment_name
  }
}

resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault_secret" "clickhouse_password" {
  name         = "clickhouse-password"
  value        = random_password.clickhouse.result
  key_vault_id = var.key_vault_id
}
