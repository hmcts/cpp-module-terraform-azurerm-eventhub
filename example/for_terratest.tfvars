
resource_group_name      = "rg-lab-cpp-ehterratest"
eventhub_namespace_name  = "ehns-lab-cpp-ehterratest"
vnet_name                = "vnet-lab-cpp-ehterratest"
sku                      = "Standard"
capacity                 = "2"
auto_inflate_enabled     = true
maximum_throughput_units = 5


location    = "uksouth"
namespace   = "cpp"
costcode    = "terratest"
owner       = "EI"
environment = "nonlive"
application = "test"
type        = "eventhub"

hubs = {
  "eh-lab-cpp-ehterratest" = {
    partitions        = 4
    message_retention = 1
  }
}
