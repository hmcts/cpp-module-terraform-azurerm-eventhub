output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.eventhub.name
}

output "eventhub_name" {
  value = [for hub in azurerm_eventhub.events : hub.name]
}
