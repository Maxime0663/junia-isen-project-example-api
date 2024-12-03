provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

module "ressource_groupe" {
  source                    = "./modules/ressource_groupe"
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
  /*
  python_app_subnet_name        = var.python_app_subnet_name
  python_app_subnet_address_space = var.python_app_subnet_address_space
  */
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
}

module "blob_storage" {
  source              = "./modules/blob_storage"
  resource_group_name = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  storage_account_name = local.blob_storage.name
  storage_subnet_id    = module.virtual_network.python_app_subnet_id
  ip_authorized             = data.http.ip.body
}

module "app_service" {
  source                  = "./modules/app_service"                     
  resource_group_name     = module.resource_group.resource_group_name   
  resource_group_location = module.resource_group.resource_group_location                 
  app_service_sku         = var.app_service_sku                        
                    
                 
}