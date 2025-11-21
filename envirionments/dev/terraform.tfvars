resource_group = {
  rg1 = {
    rg_name    = "shivam_rg"
    location   = "Central India"
    managed_by = "terraform" # optional
    tags = {
      environment = "dev"
      project     = "terraform-setup"
      costcenter  = "CC-1001"
    }
  }

}

virtual_network = {
  vnet1 = {
    vnet_name     = "shivam_Vnet"
    rg_name       = "shivam_rg"
    location      = "Central India"
    address_space = ["10.0.0.0/16"]
    dns_servers   = ["8.8.8.8", "8.8.4.4"] # Yeh custom DNS servers set karta hai jo network ke andar resources use karenge name resolution ke liye.
    #Default Azure DNS bhi hota hai, par hum custom DNS (like Google DNS, company DNS) use kar sakte hain.
    flow_timeout_in_minutes = 15 # Azure ek TCP/UDP session ko track karta hai; agar session inactive rahe to vo after timeout close kar deta hai.
    # Default value hoti hai 4 minutes, yahan customize ki gayi hai 15 minutes.
    tags = {
      environment = "dev"
      project     = "terraform-network"
      owner       = "shivam"
    }
  }
}

subnet = {
  subnet1 = {
    subnet_name       = "shivamsubnet1"
    vnet_name         = "shivam_Vnet"
    rg_name           = "shivam_rg"
    address_prefixes  = ["10.0.0.0/24"]
    service_endpoints = ["Microsoft.Storage"] # Matlab agar VM is subnet me hai aur Storage Account access karta hai, traffic Azure backbone pe hi rahega (public internet nahi).
    # delegation = [ # Matlab us service ko permission milti hai is subnet me apne resources deploy karne ki.
    #   {
    #     name = "delegation1"
    #     service_delegation = { # Is block me hum define karte hain kaun si service ko subnet delegate karna hai.
    #       name    = "Microsoft.Web/serverFarms" # Delegating subnet to App Service (server farms) so that it can host Web Apps inside VNet
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/action"] # Defines allowed actions that service can perform on subnet (like network join, modify)
    #     }
    #   }
    # ]
  }

  subnet2 = {
    subnet_name      = "shivamsubnet2"
    vnet_name        = "shivam_Vnet"
    rg_name          = "shivam_rg"
    address_prefixes = ["10.0.1.0/24"]

    private_endpoint_network_policies     = "Disabled"
    private_link_service_network_policies = "Enabled"

    # delegation = [
    #   {
    #     name = "delegation1"
    #     service_delegation = {
    #       name    = "Microsoft.Web/serverFarms"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    #     }
    #   }
    # ]
  }
}

public_ip = {
  lbpip = {
    pip_name                = "mehapip1"
    rg_name                 = "shivam_rg"
    location                = "Central India"
    allocation_method       = "Static"
    sku                     = "Standard"
    idle_timeout_in_minutes = 10
    domain_name_label       = "shivam-lb"
    zones                   = ["1", "2", "3"]
    tags = {
      environment = "dev"
      project     = "loadbalancer"
    }
  }

  bastion_pip = {
    pip_name          = "mehapip2"
    rg_name           = "shivam_rg"
    location          = "Central India"
    allocation_method = "Static"
    sku               = "Standard"
    domain_name_label = "shivam-bastion"
  }

  # natgateway_pip = {
  #   pip_name          = "mehapip3"
  #   rg_name           = "shivam_rg"
  #   location          = "Central India"
  #   allocation_method = "Static"
  #   sku               = "Standard"
  #   tags = {
  #     environment = "network"
  #     owner       = "shivam"
  #   }
  # }
}


network_nic = {
  nic1 = {
    nic_name                      = "shivamnic1"
    location                      = "Central India"
    rg_name                       = "shivam_rg"
    ip_config_name                = "internal"
    private_ip_meth               = "Dynamic"
    subnet_name                   = "shivamsubnet1"
    vnet_name                     = "shivam_Vnet"
    enable_accelerated_networking = true
    tags = {
      environment = "dev"
      owner       = "shivam"
    }
  }

  nic2 = {
    nic_name             = "shivamnic2"
    location             = "Central India"
    rg_name              = "shivam_rg"
    ip_config_name       = "internal"
    private_ip_meth      = "Dynamic"
    subnet_name          = "shivamsubnet2"
    vnet_name            = "shivam_Vnet"
    enable_ip_forwarding = true
  }
}


virtual_machine = {
  vm1 = {
    vm_name        = "lbvm1"
    rg_name        = "shivam_rg"
    location       = "Central India"
    vm_size        = "Standard_B1s"
    admin_username = "Useradmin"
    admin_password = "Useradmin@1234"
    nic_name       = "shivamnic1"
  }

  vm2 = {
    vm_name        = "lbvm2"
    rg_name        = "shivam_rg"
    location       = "Central India"
    vm_size        = "Standard_B1s"
    admin_username = "Useradmin"
    admin_password = "Useradmin@1234"
    nic_name       = "shivamnic2"
  }
}


loadbalancer = {
  lb1 = {
    lb_name           = "TestLoadBalancer"
    location          = "Central India"
    rg_name           = "shivam_rg"
    frontend_ip_name  = "frontendlbip"
    backend_pool_name = "BackEndAddressPool"
    lb_rule_name      = "newrule1"
    protocol          = "Tcp"
    frontend_port     = 80
    backend_port      = 80
    lb_prob_name      = "lbprob1"
    lb_prob_port      = 80
    pip_name          = "mehapip1"
  }
}

network_nsg = {
  nsg1 = {
    nsg_name = "web-nsg"
    location = "eastus"
    rg_name  = "shivam_rg"

    rules = [
      {
        rule_name                  = "allow-ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        rule_name                  = "allow-http"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg2 = {
    nsg_name = "db-nsg"
    location = "eastus"
    rg_name  = "shivam_rg"
    rules = [
      {
        rule_name                  = "allow-sql"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}


azure_bastion = {
  bastion1 = {
    bastion_name       = "demo-bastion"
    location           = "eastus"
    rg_name            = "shivam_rg"
    vnet_name          = "demo-vnet"
    bastion_subnetname = "shivamsubnet2"
    address_prefixes   = ["10.0.3.0/27"]
    pip_name           = "mehapip1"
  }
}

sql_data_server = {

  sqldata = {

    sql_server_name = "mssqlserver"
    rg_name         = "shivam_rg"
    location        = "Central India"
    version         = "12.0"
    userlogin       = "Useradmin"
    userpassword    = "Useradmin@1234"
    minimum_version = "1.2"
    database_name   = "shivamdb-db"

  }

}



keyvaults = {
  kv-eastus = {
    keyvault_name              = "shivam-kv-eastus"
    location                   = "Central India"
    rg_name                    = "shivam_rg"
    sku_name                   = "premium"
    soft_delete_retention_days = 30
    key_permissions            = ["Create", "Get", "List"]
    secret_permissions         = ["Set", "Get", "Delete", "Recover"]
  }


}


aks_clusters = {
  dev = {
    cluster_name       = "aks-dev"
    location           = "eastus"
    rg_name            = "shivam_rg"
    dns_prefix         = "devaks"
    kubernetes_version = "1.30.0"
    identity_type      = "SystemAssigned" # 👈 added

    default_node_pool = {
      name       = "systempool"
      node_count = 1
      vm_size    = "standard_a2_v2"
    }

    network_profile = {
      network_plugin    = "azure"
      network_policy    = "calico"
      load_balancer_sku = "standard"
    }

    tags = {
      env = "dev"
    }
  }
}


