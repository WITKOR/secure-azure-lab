resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source = "./modules/network"

  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  tags                    = var.tags
  vnet_name               = var.vnet_name
  vnet_address_space      = var.vnet_address_space
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  nsg_name                = var.nsg_name
  allowed_admin_ip        = var.allowed_admin_ip
}

resource "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_policy_definition" "require_environment_tag" {
  name         = "require-environment-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require environment tag"
  description  = "Deny creation of resources that do not have the environment tag."

  policy_rule = jsonencode({
    "if" = {
      "field"  = "tags['environment']"
      "exists" = "false"
    }
    "then" = {
      "effect" = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "assign_require_environment_tag" {
  name                 = "assign-require-environment-tag"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.require_environment_tag.id
}

resource "azurerm_policy_definition" "deny_public_storage" {
  name         = "deny-public-storage"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny public storage accounts"

  policy_rule = jsonencode({
    "if" = {
      "allOf" = [
        {
          "field"  = "type"
          "equals" = "Microsoft.Storage/storageAccounts"
        },
        {
          "field"  = "Microsoft.Storage/storageAccounts/allowBlobPublicAccess"
          "equals" = true
        }
      ]
    },
    "then" = {
      "effect" = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "assign_deny_public_storage" {
  name                 = "assign-deny-public-storage"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.deny_public_storage.id
}

resource "azurerm_policy_definition" "enforce_https" {
  name         = "enforce-https"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce HTTPS Only"

  policy_rule = jsonencode({
    "if" = {
      "anyOf" = [
        {
          "field"  = "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly"
          "equals" = false
        }
      ]
    },
    "then" = {
      "effect" = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "assign_enforce_https" {
  name                 = "assign-enforce-https"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.enforce_https.id
}
