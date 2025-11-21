variable "resource_group" {
  type = map(object({
    rg_name    = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "virtual_network" {
  type = map(object({
    vnet_name               = string
    rg_name                 = string
    location                = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    bgp_community           = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))
  }))
}


variable "subnet" {
  type = map(object({
    subnet_name                           = string
    vnet_name                             = string
    rg_name                               = string
    address_prefixes                      = list(string)
    service_endpoints                     = optional(list(string))
    private_endpoint_network_policies     = optional(string)
    private_link_service_network_policies = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })), [])
  }))
}


variable "public_ip" {
  type = map(object({
    pip_name                = string
    rg_name                 = string
    location                = string
    allocation_method       = string
    sku                     = optional(string)
    idle_timeout_in_minutes = optional(number)
    domain_name_label       = optional(string)
    ip_version              = optional(string)
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    reverse_fqdn            = optional(string)
    tags                    = optional(map(string))
  }))
}

variable "network_nic" {
  type = map(object({
    nic_name        = string
    location        = string
    rg_name         = string
    ip_config_name  = string
    private_ip_meth = string
    subnet_name     = string
    vnet_name       = string
    # enable_accelerated_networking = optional(bool)
    # enable_ip_forwarding          = optional(bool)
    dns_servers                = optional(list(string))
    private_ip_address         = optional(string)
    private_ip_address_version = optional(string)
    public_ip_address_id       = optional(string)
    primary                    = optional(bool)
    tags                       = optional(map(string))
  }))
}



variable "virtual_machine" {
  type = map(object({
    vm_name        = string
    rg_name        = string
    location       = string
    vm_size        = string
    admin_username = string
    admin_password = string
    nic_name       = string
  }))
}


variable "loadbalancer" {
  description = "Map of Load Balancers with configuration details"
  type = map(object({
    lb_name           = string
    location          = string
    rg_name           = string
    frontend_ip_name  = string
    backend_pool_name = string
    lb_rule_name      = string
    protocol          = string
    frontend_port     = number
    backend_port      = number
    lb_prob_name      = string
    lb_prob_port      = number
    pip_name          = string
    # Optional attributes (future-ready)
    sku                     = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number, 4)
  }))
}



variable "network_nsg" {
  description = "Map of Network Security Groups and their rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_name  = string
    rules = optional(list(object({
      rule_name                  = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}


variable "azure_bastion" {
  description = "Bastion setup configuration"
  type = map(object({
    bastion_name       = string
    location           = string
    rg_name            = string
    vnet_name          = string
    bastion_subnetname = string
    address_prefixes   = list(string)
    pip_name           = string
  }))
}

variable "sql_data_server" {
  description = "Map of SQL Server configurations with their associated databases"
  type = map(object({
    sql_server_name = string
    rg_name         = string
    location        = string
    version         = string
    userlogin       = string
    userpassword    = string
    minimum_version = optional(string, "1.2")
    database_name   = string
  }))
}



variable "keyvaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    keyvault_name              = string
    location                   = string
    rg_name                    = string
    sku_name                   = optional(string)
    soft_delete_retention_days = optional(number)
    key_permissions            = optional(list(string))
    secret_permissions         = optional(list(string))
  }))
}


variable "aks_clusters" {
  description = "Map of AKS cluster configurations"
  type = map(object({
    cluster_name       = string
    location           = string
    rg_name            = string
    dns_prefix         = string
    kubernetes_version = optional(string)
    sku_tier           = optional(string)
    identity_type      = optional(string)
    rbac_enabled       = optional(bool)
    tags               = optional(map(string))

    default_node_pool = object({
      name            = string
      node_count      = number
      vm_size         = string
      os_disk_size_gb = optional(number)
      subnet_id       = optional(string)
    })

    network_profile = optional(object({
      network_plugin    = optional(string)
      network_policy    = optional(string)
      load_balancer_sku = optional(string)
    }), {})
  }))
}

