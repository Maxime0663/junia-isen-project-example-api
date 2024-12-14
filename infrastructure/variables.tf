variable subscription_id {
  description = "The Azure subscription ID"
  type        = string
  sensitive   = true
}

# Resource Group Variables

variable resource_group_name {
  description = "The name of the resource group"
  type        = string
  default     = "Ressource_projet"
}

variable resource_group_location {
  description = "The location of the resource group"
  type        = string
  default     = "France Central"
}

# Virtual Network Variables

variable virtual_network_name {
  description = "The name of the virtual network"
  type        = string
  default     = "projet_vn"
}

variable virtual_network_address_space {
  description = "The address space that is used by the virtual network"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

variable database_subnet_name {
  description = "The name of the database subnet"
  type        = string
  default     = "database-subnet"
}

variable database_subnet_address_space {
  description = "The address space that is used by the database subnet"
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable python_app_subnet_name {
  description = "The name of the Python app subnet"
  type        = string
  default     = "python-app-subnet"
}

variable python_app_subnet_address_space {
  description = "The address space that is used by the Python app subnet"
  type        = list(string)
  default     = ["192.168.2.0/24"]
}

variable application_gateway_subnet_name {
  description = "The name of the Application Gateway subnet"
  type        = string
  default     = "app-gateway-subnet"
}

variable application_gateway_subnet_address_space {
  description = "The address space that is used by the Application Gateway subnet"
  type        = list(string)
  default     = ["192.168.3.0/24"]
}

# Database Variables

variable dns_zone_name {
  description = "The name of the DNS zone"
  type        = string
  default     = "projetdatabase-dns.postgres.database.azure.com"
}

variable dns_zone_link_name {
  description = "The name of the DNS zone link"
  type        = string
  default     = "projetdatabase-dns"
}

variable database_admin_username {
  description = "The username of the database admin"
  type        = string
  sensitive   = true
  default     = "maxime.blouin@student.junia.com" 
}

variable database_admin_password {
  description = "The password of the database admin"
  type        = string
  sensitive   = true
}

variable database_name {
  description = "The name of the database"
  type        = string
  default     = "projetdatabase-db"
}

variable server_name {
  description = "The name of the database server"
  type        = string
  default     = "projetdatabase-srv"
}

variable "ip_authorized" {
  description = "The IP address that is authorized to access the database"
  type        = string
  default     = "data.http.ip.response_body"
}

# App Service Variables

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     ="Projet-app-service-plan"
}   

variable app_service_name {
  description = "The name of the App Service"
  type        = string
  default     = "blouin-petit-python-app-service"
}

variable "app_service_sku" {
  description = "Size of the App Service Plan SKU"
  type        = string
  default     = "B1"
}


# Blob Storage Variables
variable storage_account_name {
  description = "The name of the storage account"
  type        = string
  default     = "storageblouinpetit"
}

# Application Gateway Variables

variable application_gateway_name {
  description = "The name of the Application Gateway"
  type        = string
  default     = "Projet-app-gateway"
}

variable application_gateway_sku {
  description = "The SKU of the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable application_gateway_capacity {
  description = "The capacity of the Application Gateway"
  type        = number
  default     = 2
}

variable application_gateway_frontend_ip_configuration {
  description = "The frontend IP configuration for the Application Gateway"
  type        = string
  default     = "app-gateway-frontend-ip"
}