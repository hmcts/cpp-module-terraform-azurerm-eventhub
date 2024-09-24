resource "azurerm_eventhub_namespace" "main" {
  name                          = var.eventhub_namespace_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.capacity
  auto_inflate_enabled          = var.auto_inflate_enabled
  maximum_throughput_units      = !var.auto_inflate_enabled ? "0" : var.maximum_throughput_units
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_rulesets" {
    for_each = var.network_rulesets
    content {
      default_action                 = network_rulesets.value.default_action
      trusted_service_access_enabled = true
      public_network_access_enabled  = var.public_network_access_enabled
      dynamic "ip_rule" {
        for_each = network_rulesets.value.ip_rule
        content {
          ip_mask = ip_rule.value.ip_mask
          action  = ip_rule.value.action
        }
      }
      dynamic "virtual_network_rule" {
        for_each = network_rulesets.value.virtual_network_rule
        content {
          subnet_id                                       = virtual_network_rule.value.subnet_id
          ignore_missing_virtual_network_service_endpoint = virtual_network_rule.value.ignore_missing_virtual_network_service_endpoint
        }
      }
    }
  }
  tags = var.tags
}

resource "azurerm_eventhub" "main" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}
