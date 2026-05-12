# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "laws_name" {
  description = "LAWS Name"
  value       = module.lz_management_resources.log_analytics_workspace.name
}

output "laws_rgname" {
  description = "LAWS Resource Group Name"
  value       = local.resource_group_name
}

output "laws_resource_id" {
  description = "LAWS Resource ID"
  value       = module.lz_management_resources.log_analytics_workspace.id
}

output "laws_workspace_id" {
  description = "LAWS Workspace ID"
  value       = module.lz_management_resources.log_analytics_workspace.workspace_id
}

output "laws_primary_shared_key" {
  description = "LAWS Primary Shared Key"
  sensitive   = true
  value       = module.lz_management_resources.log_analytics_workspace_keys.primary
}

output "laws_secondary_shared_key" {
  description = "LAWS Secondary Shared Key"
  sensitive   = true
  value       = module.lz_management_resources.log_analytics_workspace_keys.secondary
}

output "laws_storage_account_id" {
  description = "LAWS Storage Account ID"
  value       = module.mod_loganalytics_sa.storage_account_id
}

output "laws_storage_account_name" {
  description = "LAWS Storage Account Name"
  value       = local.ops_logging_law_sa_name
}

output "laws_storage_account_rgname" {
  description = "LAWS Storage Account Resource Group Name"
  value       = local.resource_group_name
}

output "laws_storage_account_location" {
  description = "LAWS Storage Account Location"
  value       = local.location
}

output "automation_account_id" {
  description = "Automation Account ID"
  value       = module.lz_management_resources.automation_account.id
}

output "automation_account_name" {
  description = "Automation Account Name"
  value       = local.automation_account_name
}

output "automation_account_dsc_server_endpoint" {
  description = "Automation Account Resource Group Name"
  value       = module.lz_management_resources.automation_account.dsc_server_endpoint
}

output "automation_account_identity" {
  description = "Automation Account Identity"
  value       = module.lz_management_resources.automation_account.identity
}


