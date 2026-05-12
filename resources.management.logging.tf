# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Operations Log Analytics Workspace Creation
#----------------------------------------------------------
module "lz_management_resources" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.9"

  enable_telemetry = var.enable_telemetry

  # Resource Group Details
  location                        = local.location
  resource_group_name             = local.resource_group_name
  resource_group_creation_enabled = false # Resource Group is created by sibling overlay

  # Automation Account Configuration
  linked_automation_account_creation_enabled       = var.enable_linked_automation_account_creation
  automation_account_name                          = local.automation_account_name
  automation_account_local_authentication_enabled  = var.enable_automation_account_local_authentication
  automation_account_public_network_access_enabled = var.enable_automation_account_public_network_access
  automation_account_sku_name                      = var.automation_account_sku_name

  # Automation Account Managed Identity Configuration
  automation_account_identity = var.enable_linked_automation_account_creation && var.enable_automation_account_user_assigned_identity ? {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.management[0].id]
    } : {
    type         = "SystemAssigned"
    identity_ids = null
  }

  # Automation Account Encryption Configuration
  # NOTE: `key_vault_url` is no longer supported by the AVM module; only `key_vault_key_id`
  # (a full Key Vault key URL) plus an optional `user_assigned_identity_id` are accepted.
  automation_account_encryption = var.enable_linked_automation_account_creation && var.enable_automation_account_encryption ? {
    key_vault_key_id          = var.automation_account_key_vault_key_id
    user_assigned_identity_id = var.enable_automation_account_user_assigned_identity ? azurerm_user_assigned_identity.management[0].id : null
  } : null

  # Log Analytics Workspace Configuration
  log_analytics_workspace_name                               = local.ops_logging_law_name
  log_analytics_workspace_allow_resource_only_permissions    = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_sku == "CapacityReservation" ? var.log_analytics_workspace_reservation_capacity_in_gb_per_day : null
  log_analytics_workspace_retention_in_days                  = var.log_analytics_logs_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku

  # Log Analytics Solutions Configuration
  # The new AVM schema accepts only `product` and `publisher`. The legacy `SecurityInsights`
  # solution plan is excluded here because the AVM module onboards Sentinel via the
  # dedicated `sentinel_onboarding` input (see below).
  log_analytics_solution_plans = [
    for solution in local.log_analytics_solutions : {
      product   = solution.product
      publisher = solution.publisher
    }
    if solution.deploy == true && solution.name != "SecurityInsights"
  ]

  # Sentinel onboarding replaces the deprecated SecurityInsights solution plan.
  sentinel_onboarding = var.enable_sentinel ? {} : null
}
