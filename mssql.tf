# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg2" {
    name     = "${var.prefix}-sa-rg"
    location = "southeastasia"

    tags = {
        environment = var.tag
    }
}

resource "azurerm_sql_server" "tfrg" {
    name                         = "${var.prefix}sqlsvr"
    resource_group_name          = azurerm_resource_group.tfrg2.name
    location                     = azurerm_resource_group.tfrg2.location
    version                      = "12.0"
    administrator_login          = var.admin_username
    administrator_login_password = var.admin_password
}

resource "azurerm_sql_database" "tfrg" {
    name                = "${var.prefix}sqldb"
    resource_group_name = azurerm_resource_group.tfrg2.name
    location            = azurerm_resource_group.tfrg2.location
    server_name         = azurerm_sql_server.tfrg.name

    edition             = "Basic"
}

# https://blogs.technet.microsoft.com/livedevopsinjapan/2017/08/17/enabling-allow-access-to-azure-service-by-terraform/
resource "azurerm_sql_firewall_rule" "tfrg" {
    name                = "Allow All Azure Service"
    resource_group_name = azurerm_resource_group.tfrg2.name
    server_name         = azurerm_sql_server.tfrg.name
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "localip" {
    name                = "Allow local pc ip"
    resource_group_name = azurerm_resource_group.tfrg2.name
    server_name         = azurerm_sql_server.tfrg.name
    start_ip_address    = var.local_ip
    end_ip_address      = var.local_ip
}
