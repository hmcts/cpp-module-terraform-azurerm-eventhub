variable "location" {
  type    = string
  default = "uksouth"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "costcode" {
  type        = string
  description = "Name of theDWP PRJ number (obtained from the project portfolio in TechNow)"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also"
  default     = ""
}


variable "application" {
  type        = string
  description = "Application to which the s3 bucket relates"
  default     = ""
}

variable "attribute" {
  type        = string
  description = "An attribute of the s3 bucket that makes it unique"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment into which resource is deployed"
  default     = ""
}

variable "type" {
  type        = string
  description = "Name of service type"
  default     = ""
}

variable "version_number" {
  type        = string
  description = "The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment"
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
  default     = "rg-lab-cpp-saterratest"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  type    = string
  default = ""
}

variable "eventhub_namespace_name" {
  description = "(Required) Specifies the name of the Eventhub namespace."
  type        = string
}


variable "sku" {
  description = "(Required) Specifies the SKU of the Eventhub."
  type        = string
}

variable "capacity" {
  description = "(Optional) Specifies the capacity of the Eventhub."
  type        = string
}

variable "auto_inflate_enabled" {
  description = "(Optional) Specifies if the Eventhub should automatically inflate."
  type        = bool
}

variable "maximum_throughput_units" {
  description = "(Optional) Specifies the maximum throughput units when auto inflate is enabled."
  type        = number
}

variable "hubs" {
  type = map(object({
    partitions        = number
    message_retention = number
    consumers         = optional(list(string), [])
    keys = optional(map(object({
      listen = bool
      send   = bool
      manage = bool
    })), {})
  }))

  description = "A map of hubs, where the key is the hub name and each hub contains partitions, message_retention, a list of consumers, and keys for each consumer."

}
