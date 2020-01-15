# Run local-exec on Linux/Azure Shell
# deploy apiapp
resource "null_resource" "apiapp" {
  count = var.zipdeploy ? 1 : 0

  provisioner "local-exec" {
    command = "curl -s -X POST -T ./assets/apiapp.zip -u '${azurerm_app_service.tfrg.site_credential[0].username}:${azurerm_app_service.tfrg.site_credential[0].password}' https://${azurerm_app_service.tfrg.name}.scm.azurewebsites.net/api/zipdeploy"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [azurerm_app_service.tfrg]
}

# sqlcmd installed in your environment
resource "null_resource" "mssql" {
  provisioner "local-exec" {
    command = "sqlcmd -S ${azurerm_sql_server.tfrg.name}.database.windows.net -d ${azurerm_sql_database.tfrg.name} -U ${var.admin_username} -P ${var.admin_password} -Q \"drop table events; create table events (id bigint identity primary key, message nvarchar(max), timecreated datetime)\""
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [azurerm_sql_database.tfrg]
}
