resource "azurerm_app_service_plan" "tfrg" {
  name                = "${var.prefix}-svcplan"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "tfrg" {
  name                = "${var.prefix}api"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  app_service_plan_id = azurerm_app_service_plan.tfrg.id

  site_config {
    always_on                = "true"
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    EVENTS_SQLCONN = "Server=tcp:${azurerm_sql_server.tfrg.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.tfrg.name};Persist Security Info=False;User ID=${var.admin_username};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

}

# remove this comment if you want to deploy using ARM template
resource "azurerm_template_deployment" "tfrg" {
  count               = var.zipdeploy ? 0 : 1

  name                = "${var.prefix}-appdeploy"
  resource_group_name = azurerm_resource_group.tfrg.name

  template_body = file(var.webapp_template_path)

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    appName = azurerm_app_service.tfrg.name
    hostingPlanName = azurerm_app_service_plan.tfrg.name
    packageUri = var.package_url
    sqlconn = "Server=tcp:${azurerm_sql_server.tfrg.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.tfrg.name};Persist Security Info=False;User ID=${var.admin_username};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  deployment_mode = "Incremental"

  depends_on = [azurerm_app_service.tfrg]
}

output "webapp_site_credentials" {
  value = azurerm_app_service.tfrg.site_credential
}

output "webapp_test" {
  value = "https://${azurerm_app_service.tfrg.default_site_hostname}"
}