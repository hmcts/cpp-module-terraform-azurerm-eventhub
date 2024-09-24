output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "resource_group_name" {
  value = azurerm_resource_group.test.name
}

output "eventhub_namespace_name" {
  value = module.eventhub.eventhub_namespace_name
}

output "eventhub_name" {
  value = module.eventhub.eventhub_name
}
