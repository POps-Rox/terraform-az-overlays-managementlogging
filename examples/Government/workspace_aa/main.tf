module "mod_logging" {
  source = "../../.." # Path to the root of the repository

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = var.workload_name

  ########################################
  ## Automation Account Configuration  ###
  ########################################

  # Enable Automation Account Linking to Log Analytics Workspace
  enable_linked_automation_account_creation = true
  automation_account_sku_name               = "Basic"

  #############################
  ## Logging Configuration  ###
  #############################

  # Log Analytics Workspace Configuration
  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = true
  log_analytics_workspace_daily_quota_gb                     = 1
  log_analytics_workspace_internet_ingestion_enabled         = true
  log_analytics_workspace_internet_query_enabled             = true
  log_analytics_workspace_reservation_capacity_in_gb_per_day = 200
  log_analytics_logs_retention_in_days                       = 50
  log_analytics_workspace_sku                                = "PerGB2018"

  # (Optional) Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel           = true
  enable_azure_activity_log = true
  enable_vm_insights        = true

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
