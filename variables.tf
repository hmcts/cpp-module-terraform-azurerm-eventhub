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
  description = "Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also"
  type        = string
  default     = ""
}


variable "application" {
  description = "Application to which the s3 bucket relates"
  type        = string
  default     = ""
}

variable "attribute" {
  description = "An attribute of the s3 bucket that makes it unique"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment into which resource is deployed"
  type        = string
  default     = ""
}

variable "type" {
  description = "Name of service type"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the event hub. Changing this forces a new resource to be created."
  type        = string
}

variable "eventhub_namespace_name" {
  description = "(Required) Specifies the name of the Eventhub namespace."
  type        = string
}

variable "sku" {
  description = "(Required) Defines which tier to use. Valid options are Basic and Standard."
  type        = string
}

variable "capacity" {
  description = " (Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  default     = "1"
  type        = string
}

variable "auto_inflate_enabled" {
  description = "(Optional) Is Auto Inflate enabled for the EventHub Namespace?"
  default     = false
  type        = bool
}

variable "maximum_throughput_units" {
  description = " (Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20."
  default     = null
  type        = number
}

variable "network_rulesets" {
  description = <<-EOF
  A map of network_rulesets blocks as defined below.
  {
    [ruleset_name] = {
      default_action = ["Allow" || "Deny"]
      ip_rule = [ # (Optional)
        {
          ip_mask = "x.x.x.x/xx"
          action  = ["Allow" || "Deny"]
        }
      virtual_network_rule = [
        {
          subnet_id                                       = [subnet_id]
          ignore_missing_virtual_network_service_endpoint = [true || false]
        }
      ]
    }
  }
  EOF

  type = map(object({
    default_action = string
    ip_rule = map(object({
      ip_mask = string
      action  = string
    }))
    virtual_network_rule = map(object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = bool
    }))
  }))
}

variable "public_network_access_enabled" {
  description = "(Optional) Is Public Network Access enabled for the EventHub Namespace?"
  default     = true
  type        = bool
}

variable "local_authentication_enabled" {
  description = "(Optional) Is SAS authentication enabled for the EventHub Namespace?"
  default     = true
  type        = bool
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum supported TLS version for this EventHub Namespace. Valid values are: 1.0, 1.1 and 1.2"
  default     = "1.2"
  type        = string
}

variable "identity" {
  description = "Identity block Specifies the identity to assign to function app"
  type        = any
  default     = {}
}

variable "authorization_rules" {
  description = "Authorization rules to add to the namespace. For hub use `hubs` variable to add authorization keys."
  type = map(object({
    listen = bool
    send   = bool
    manage = bool
  }))
  default = {}
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

  description = "A map of hubs, where the key is the hub name and each hub contains partitions, message_retention, a list of consumers, and authorisation rules(key is the name and the permissions)."

}
