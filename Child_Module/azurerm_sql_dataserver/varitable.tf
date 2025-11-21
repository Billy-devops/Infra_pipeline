
variable "sql_data_server" {
  description = "Map of SQL Server configurations with their associated databases"
  type = map(object({
    sql_server_name  = string
    rg_name          = string
    location         = string
    version          = string
    userlogin        = string
    userpassword     = string
    minimum_version  = optional(string, "1.2")
    database_name    = string
  }))
}
