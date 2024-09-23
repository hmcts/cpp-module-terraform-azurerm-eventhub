output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.main.name
}

output "eventhub_name" {
  value = azurerm_eventhub.main.name
}
