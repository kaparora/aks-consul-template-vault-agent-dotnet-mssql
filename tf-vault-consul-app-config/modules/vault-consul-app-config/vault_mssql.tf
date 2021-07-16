resource "vault_mount" "mssql" {
  path = "database/mssql"
  type = "database"
}

resource "vault_database_secret_backend_connection" "mssql" {
  backend       = vault_mount.mssql.path
  name          = "demo"
  allowed_roles = ["dotnet-app", "dotnet-app-long"]

  mssql {
    connection_url = "sqlserver://SA:Testing!123@localhost:1433"
  }
}

resource "vault_database_secret_backend_role" "dotnet-app" {
  backend             = vault_mount.mssql.path
  name                = "dotnet-app"
  db_name             = vault_database_secret_backend_connection.mssql.name
  creation_statements = ["CREATE LOGIN [{{name}}] WITH PASSWORD = '{{password}}';",
                         "USE HashiCorp;",
                         "CREATE USER [{{name}}] FOR LOGIN [{{name}}];",
                         "GRANT SELECT,UPDATE,INSERT,DELETE TO [{{name}}];",]
  default_ttl          = 180
  max_ttl              = 360
}

resource "vault_database_secret_backend_role" "dotnet-app-long" {
  backend             = vault_mount.mssql.path
  name                = "dotnet-app-long"
  db_name             = vault_database_secret_backend_connection.mssql.name
  creation_statements = ["CREATE LOGIN [{{name}}] WITH PASSWORD = '{{password}}';",
                         "USE HashiCorp;",
                         "CREATE USER [{{name}}] FOR LOGIN [{{name}}];",
                         "GRANT SELECT,UPDATE,INSERT,DELETE TO [{{name}}];",]
  default_ttl          = 3600
  max_ttl              = 86400
}

