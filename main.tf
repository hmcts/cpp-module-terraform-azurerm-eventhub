
locals {
  consumer_groups = {
    for item in flatten([
      for hub_key, hub_value in var.hubs : [
        for consumer in hub_value.consumers : {
          consumer   = consumer
          hub        = hub_key
          unique_key = "${consumer}_${hub_key}"
        }
      ]
    ]) : item.unique_key => item
  }

  authorization_rules = {
    for item in flatten([
      for hub_key, hub_value in var.hubs :
      [
        for app_key, app_value in hub_value.keys :
        {
          key         = "${hub_key}_${app_key}" # Unique key for each rule
          hub_name    = hub_key                 # Hub name
          permissions = app_value               # Permissions object
        }
      ]
      ]) : item.key => {
      hub_name    = item.hub_name
      permissions = item.permissions
    }
  }
}



resource "azurerm_eventhub_namespace" "eventhub" {
  name                 = var.eventhub_namespace_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  sku                  = var.sku
  capacity             = var.capacity
  auto_inflate_enabled = var.auto_inflate_enabled


  dynamic "identity" {
    for_each = var.identity == {} ? [] : [var.identity]
    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  maximum_throughput_units = var.maximum_throughput_units

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

  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version

  tags = var.tags
}

resource "azurerm_eventhub" "events" {
  for_each = var.hubs

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partitions
  message_retention   = each.value.message_retention
}


resource "azurerm_eventhub_namespace_authorization_rule" "events" {
  for_each = var.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = var.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_eventhub_consumer_group" "events" {
  for_each = local.consumer_groups

  name                = each.value.consumer
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_eventhub.events]
}

resource "azurerm_eventhub_authorization_rule" "events" {
  for_each = local.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  eventhub_name       = each.value.hub_name
  resource_group_name = var.resource_group_name

  listen = each.value.permissions.listen
  send   = each.value.permissions.send
  manage = each.value.permissions.manage

  depends_on = [azurerm_eventhub.events]
}
