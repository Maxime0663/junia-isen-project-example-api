provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  storage_use_azuread        = true
}

# Permet de récupérer l'adresse IP publique de l'utilisateur
data "http" "ip" {
  url = "https://api.ipify.org"
}

module "resource_group" {
  source                    = "./modules/resource_group"
  resource_group_name       = var.resource_group_name
  resource_group_location   = var.resource_group_location
} 

module "virtual_network" {
  source                        = "./modules/virtual_network"
  resource_group_name           = module.resource_group.resource_group_name
  resource_group_location       = module.resource_group.resource_group_location
  virtual_network_name          = var.virtual_network_name
  virtual_network_address_space = var.virtual_network_address_space

  database_subnet_name          = var.database_subnet_name
  database_subnet_address_space = var.database_subnet_address_space
  
  python_app_subnet_name        = var.python_app_subnet_name
  python_app_subnet_address_space = var.python_app_subnet_address_space

  application_gateway_subnet_name = var.application_gateway_subnet_name
  application_gateway_subnet_address_space = var.application_gateway_subnet_address_space
}

module "database" {
  source                    = "./modules/database"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  vnet_id                   = module.virtual_network.virtual_network_id
  database_subnet_id        = module.virtual_network.database_subnet_id
  dns_zone_name             = var.dns_zone_name
  dns_zone_link_name        = var.dns_zone_link_name
  database_admin_username   = var.database_admin_username
  database_admin_password   = var.database_admin_password
  database_name             = var.database_name
  server_name               = var.server_name
  ip_authorized             = data.http.ip.response_body
}

module "blob_storage" {
  source              = "./modules/blob_storage"
  resource_group_name = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  storage_account_name = var.storage_account_name
  storage_subnet_id    = module.virtual_network.python_app_subnet_id
  ip_authorized             = data.http.ip.body

  app_service_principal_id = module.app_service.principal_id
}

module "application_gateway" {
  source                              = "./modules/application_gateway"
  resource_group_name                 = module.resource_group.resource_group_name
  resource_group_location             = module.resource_group.resource_group_location
  application_gateway_name            = var.application_gateway_name
  application_gateway_sku             = var.application_gateway_sku
  application_gateway_capacity        = var.application_gateway_capacity
  application_gateway_frontend_ip_configuration = var.application_gateway_frontend_ip_configuration
  subnet_id                           = module.virtual_network.application_gateway_subnet_id
  backend_fqdn                        = "${var.app_service_name}.azurewebsites.net"
}

module "app_service" {
  source              = "./modules/app_service"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  app_service_name = var.app_service_name
  app_service_plan_name = var.app_service_plan_name

  docker_image = "maximeblouin/cloud_computing_api_project:main"
  docker_registry_url = "https://ghcr.io"

  gateway_ip = module.application_gateway.public_ip_address  
  subnet_id = module.virtual_network.python_app_subnet_id

  app_settings = {
    STORAGE_BLOB_URL  = module.blob_storage.storage_url
    
    DATABASE_HOST     = module.database.db_host
    DATABASE_PORT     = module.database.db_port
    DATABASE_NAME     = module.database.db_name
    DATABASE_USERNAME = module.database.db_admin_username
    DATABASE_PASSWORD = module.database.db_admin_password
  }
}