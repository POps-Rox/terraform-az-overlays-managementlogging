# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Operations Log Analytics Workspace Diagnostic Setting
#----------------------------------------------------------
module "mod_log_diagnostic_settings" {
  source = "github.com/POps-Rox/terraform-az-overlays-diagnosticsettings"

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = var.workload_name

  custom_diagnostic_setting_name = format("%s-%s-log-analytics-diagnostic-log", var.org_name, var.workload_name)
  resource_id                    = module.lz_management_resources.log_analytics_workspace.id
  logs_destinations_ids          = [module.lz_management_resources.log_analytics_workspace.id, module.mod_loganalytics_sa.storage_account_id]
}

#---------------------------------------------------------
# Automation Account Diagnostic Setting
#----------------------------------------------------------
module "mod_aa_diagnostic_settings" {
  source = "github.com/POps-Rox/terraform-az-overlays-diagnosticsettings"

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = var.workload_name

  custom_diagnostic_setting_name = format("%s-%s-aa-diagnostic-log", var.org_name, var.workload_name)
  resource_id                    = module.lz_management_resources.automation_account.id
  logs_destinations_ids          = [module.lz_management_resources.log_analytics_workspace.id, module.mod_loganalytics_sa.storage_account_id]
}
