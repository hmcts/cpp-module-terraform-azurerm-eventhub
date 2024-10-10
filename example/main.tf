data "azurerm_subscription" "current" {}

locals {
  network_rulesets = {
    ruleset1 = {
      default_action = "Deny"
      ip_rule        = {}
      virtual_network_rule = {
        vnet1 = {
          subnet_id                                       = azurerm_subnet.test.id
          ignore_missing_virtual_network_service_endpoint = true
        }
      }
    }
  }
}

module "tag_set" {
  source         = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=main"
  namespace      = var.namespace
  application    = var.application
  costcode       = var.costcode
  owner          = var.owner
  version_number = var.version_number
  attribute      = var.attribute
  environment    = var.environment
  type           = var.type
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
  tags     = module.tag_set.tags
}

resource "azurerm_virtual_network" "test" {
  name                = var.vnet_name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  tags                = module.tag_set.tags
}

resource "azurerm_subnet" "test" {
  name                                          = "example-subnet"
  resource_group_name                           = azurerm_resource_group.test.name
  virtual_network_name                          = azurerm_virtual_network.test.name
  address_prefixes                              = ["10.0.1.0/24"]
  private_link_service_network_policies_enabled = false
}

module "eventhub" {
  source                   = "../"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = var.location
  eventhub_namespace_name  = var.eventhub_namespace_name
  hubs                     = var.hubs
  sku                      = var.sku
  capacity                 = var.capacity
  auto_inflate_enabled     = var.auto_inflate_enabled
  maximum_throughput_units = var.maximum_throughput_units
  network_rulesets         = local.network_rulesets
  tags                     = module.tag_set.tags
}
