resource "azurerm_mssql_server" "sqldataserver" {
  for_each = var.sql_data_server
  name                         = each.value.sql_server_name
  resource_group_name          = each.value.rg_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.userlogin
  administrator_login_password = each.value.userpassword
  minimum_tls_version          = each.value.minimum_version

  }


resource "azurerm_mssql_database" "database" {
  for_each = var.sql_data_server
  name         = each.value.database_name
  server_id    = azurerm_mssql_server.sqldataserver[each.key].id
 
  }


# resource "azurerm_mssql_server" "sqldataserver" {
#   for_each = var.sql_data_server
#   name                         = each.value.sql_server_name
#   resource_group_name          = each.value.rg_name
#   location                     = each.value.location
#   version                      = each.value.version
#   administrator_login          = each.value.userlogin
#   administrator_login_password = each.value.userpassword
#   minimum_tls_version          = each.value.minimum_version

#   }

# variable "sql_data_server" {
  
# }

# resource "azurerm_mssql_database" "database" {
#   for_each = var.sql_data_server
#   name         = each.value.database_name
#   server_id    = azurerm_mssql_server.sqldataserver[each.key].id
 
#   }



# data "azurerm_key_vault" "keyvault" {
#   for_each = var.sql_data_server
#   name                = each.value.keyvault_name
#   resource_group_name = each.value.rg_name
# }

# data "azurerm_key_vault_secret" "username" {
#   for_each = var.sql_data_server
#   name         = each.value.user_name
#   key_vault_id = data.azurerm_key_vault.keyvault[each.key].id
# }
# data "azurerm_key_vault_secret" "password" {
#   for_each = var.sql_data_server
#   name         = each.value.password_value
#   key_vault_id = data.azurerm_key_vault.keyvault[each.key].id
# }

