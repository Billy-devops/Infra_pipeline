
#################################
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
    sku               = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number, 4)
  }))
}

#################################
# NIC Variable
#################################
variable "network_nic" {
  description = "Map of Network Interface configurations"
  type = map(object({
    nic_name        = string
    location        = string
    rg_name         = string
    ip_config_name  = string
    private_ip_meth = string
    subnet_name     = string
    vnet_name       = string

    # Optional: Attach NICs to specific load balancers dynamically
    lb_key          = optional(string, "lb1")
  }))
}
