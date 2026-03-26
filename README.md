<!-- BADGES:START -->
[![CI](https://github.com/POps-Rox/tf-az-overlays-managementlogging/actions/workflows/ci.yml/badge.svg)](https://github.com/POps-Rox/tf-az-overlays-managementlogging/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/POps-Rox/tf-az-overlays-managementlogging/pulls)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/POps-Rox/tf-az-overlays-managementlogging/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9-623CE4.svg?logo=terraform)](https://www.terraform.io)
<!-- BADGES:END -->

# Azure NoOps Management Logging Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-template/azurerm/)

This module deploys logging resources (Log Analytics Workspace, Log Solutions and AMPLS) to an operations or security spoke network described in the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation](https://www.cisa.gov/secure-cloud-computing-architecture).

## Module Usage

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_operational_logging" {
  source  = "POps-Rox/tf-az-overlays-management-logging"
  version = ">= 1.0.0"

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
  enable_linked_automation_account_creation        = true
  automation_account_sku_name                      = "Basic"
  automation_account_local_authentication_enabled  = true
  automation_account_public_network_access_enabled = true

  #############################
  ## Logging Configuration  ###
  #############################

  # Log Analytics Workspace Configuration
  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = true
  log_analytics_workspace_daily_quota_gb                     = 1
  log_analytics_workspace_internet_ingestion_enabled         = true
  log_analytics_workspace_internet_query_enabled             = true
  log_analytics_workspace_reservation_capacity_in_gb_per_day = 0 # CapacityReservation is not supported in this configuration
  log_analytics_logs_retention_in_days                       = 50
  log_analytics_workspace_sku                                = "PerGB2018"

  # (Optional) Logging Solutions
  # All solutions are not enabled (false) by default
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

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.116 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.116 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lz_management_resources"></a> [lz\_management\_resources](#module\_lz\_management\_resources) | Azure/alz-management/azurerm | ~> 0.1 |
| <a name="module_mod_aa_diagnostic_settings"></a> [mod\_aa\_diagnostic\_settings](#module\_mod\_aa\_diagnostic\_settings) | azurenoops/overlays-diagnostic-settings/azurerm | ~> 1.0.4 |
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | azurenoops/overlays-azregions-lookup/azurerm | >= 1.0.0 |
| <a name="module_mod_log_diagnostic_settings"></a> [mod\_log\_diagnostic\_settings](#module\_mod\_log\_diagnostic\_settings) | azurenoops/overlays-diagnostic-settings/azurerm | ~> 1.0.4 |
| <a name="module_mod_loganalytics_sa"></a> [mod\_loganalytics\_sa](#module\_mod\_loganalytics\_sa) | azurenoops/overlays-storage-account/azurerm | >= 0.1.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | azurenoops/overlays-resource-group/azurerm | >= 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.law_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_id.uniqueString](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurenoopsutils_resource_name.ampls_snet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.automation_account](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.laws](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.logging_st](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.user_assigned_identity](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Metric_enable"></a> [Metric\_enable](#input\_Metric\_enable) | Is this Diagnostic Metric enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_ampls_subnet_custom_name"></a> [ampls\_subnet\_custom\_name](#input\_ampls\_subnet\_custom\_name) | The name of the custom subnet to create for Azure Monitor Private Link Scope. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_automation_account_custom_name"></a> [automation\_account\_custom\_name](#input\_automation\_account\_custom\_name) | The name of the custom automation account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_automation_account_key_vault_key_id"></a> [automation\_account\_key\_vault\_key\_id](#input\_automation\_account\_key\_vault\_key\_id) | The ID of the Key Vault Key to use for Automation Account encryption. | `string` | `null` | no |
| <a name="input_automation_account_key_vault_url"></a> [automation\_account\_key\_vault\_url](#input\_automation\_account\_key\_vault\_url) | The URL of the Key Vault to use for Automation Account encryption. | `string` | `null` | no |
| <a name="input_automation_account_sku_name"></a> [automation\_account\_sku\_name](#input\_automation\_account\_sku\_name) | The SKU of the Automation Account. Possible values are Basic, Free, and Standard. Default is Basic. | `string` | `"Basic"` | no |
| <a name="input_create_logging_resource_group"></a> [create\_logging\_resource\_group](#input\_create\_logging\_resource\_group) | Controls if the logging resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_days"></a> [days](#input\_days) | The number of days for which this Retention Policy should apply. | `number` | `"90"` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environnement | `string` | n/a | yes |
| <a name="input_diagnostic_setting_enabled_aa_log_categories"></a> [diagnostic\_setting\_enabled\_aa\_log\_categories](#input\_diagnostic\_setting\_enabled\_aa\_log\_categories) | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | <pre>[<br>  "AuditEvent",<br>  "Job",<br>  "JobStreams",<br>  "CompilationJob"<br>]</pre> | no |
| <a name="input_diagnostic_setting_enabled_log_categories"></a> [diagnostic\_setting\_enabled\_log\_categories](#input\_diagnostic\_setting\_enabled\_log\_categories) | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | <pre>[<br>  "Audit"<br>]</pre> | no |
| <a name="input_diagnostic_setting_enabled_metric_categories"></a> [diagnostic\_setting\_enabled\_metric\_categories](#input\_diagnostic\_setting\_enabled\_metric\_categories) | A list of metric categories to be enabled for this diagnostic setting. | `list(string)` | `[]` | no |
| <a name="input_enable_automation_account_encryption"></a> [enable\_automation\_account\_encryption](#input\_enable\_automation\_account\_encryption) | Controls if encryption should be enabled for the Automation Account. Default is false. | `bool` | `false` | no |
| <a name="input_enable_automation_account_local_authentication"></a> [enable\_automation\_account\_local\_authentication](#input\_enable\_automation\_account\_local\_authentication) | Controls if local authentication should be enabled for the Automation Account. Default is true. | `bool` | `true` | no |
| <a name="input_enable_automation_account_public_network_access"></a> [enable\_automation\_account\_public\_network\_access](#input\_enable\_automation\_account\_public\_network\_access) | Controls if public network access should be enabled for the Automation Account. Default is true. | `bool` | `true` | no |
| <a name="input_enable_automation_account_user_assigned_identity"></a> [enable\_automation\_account\_user\_assigned\_identity](#input\_enable\_automation\_account\_user\_assigned\_identity) | Controls if a Managed Identity should be created for the Automation Account. Default is false. | `bool` | `false` | no |
| <a name="input_enable_azure_activity_log"></a> [enable\_azure\_activity\_log](#input\_enable\_azure\_activity\_log) | Controls if Azure Activity Log should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_azure_security_center"></a> [enable\_azure\_security\_center](#input\_enable\_azure\_security\_center) | Controls if Azure Security Center should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Controls if Container Insights should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_diagnostic_setting"></a> [enable\_diagnostic\_setting](#input\_enable\_diagnostic\_setting) | Is this Diagnostic Setting enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_key_vault_analytics"></a> [enable\_key\_vault\_analytics](#input\_enable\_key\_vault\_analytics) | Controls if Key Vault Analytics should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_linked_automation_account"></a> [enable\_linked\_automation\_account](#input\_enable\_linked\_automation\_account) | Controls if a linked Automation Account should be created. Default is true. | `bool` | `true` | no |
| <a name="input_enable_linked_automation_account_creation"></a> [enable\_linked\_automation\_account\_creation](#input\_enable\_linked\_automation\_account\_creation) | Controls if a linked Automation Account should be created. Default is true. | `bool` | `true` | no |
| <a name="input_enable_monitoring_private_endpoints"></a> [enable\_monitoring\_private\_endpoints](#input\_enable\_monitoring\_private\_endpoints) | Enables private endpoints for monitoring resources. Default is true. | `bool` | `true` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| <a name="input_enable_sentinel"></a> [enable\_sentinel](#input\_enable\_sentinel) | Controls if Sentinel should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_service_map"></a> [enable\_service\_map](#input\_enable\_service\_map) | Controls if Service Map should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_enable_vm_insights"></a> [enable\_vm\_insights](#input\_enable\_vm\_insights) | Controls if VM Insights should be enabled. Default is true. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_eventhub_authorization_rule_id"></a> [eventhub\_authorization\_rule\_id](#input\_eventhub\_authorization\_rule\_id) | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `string` | `null` | no |
| <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name) | Specifies the name of the Event Hub where Diagnostics Data should be sent. | `string` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_linked_log_analytic_workspace_ids"></a> [linked\_log\_analytic\_workspace\_ids](#input\_linked\_log\_analytic\_workspace\_ids) | The IDs of the Log Analytics Workspaces to link to the Private Link Scope. | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| <a name="input_log_analytics_logs_retention_in_days"></a> [log\_analytics\_logs\_retention\_in\_days](#input\_log\_analytics\_logs\_retention\_in\_days) | The number of days to retain logs for. Possible values are between 30 and 730. Default is 30. | `number` | `30` | no |
| <a name="input_log_analytics_workspace_allow_resource_only_permissions"></a> [log\_analytics\_workspace\_allow\_resource\_only\_permissions](#input\_log\_analytics\_workspace\_allow\_resource\_only\_permissions) | Specifies whether the Log Analytics Workspace should only allow access to resources within the same subscription. Defaults to true. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_cmk_for_query_forced"></a> [log\_analytics\_workspace\_cmk\_for\_query\_forced](#input\_log\_analytics\_workspace\_cmk\_for\_query\_forced) | Specifies whether the Log Analytics Workspace should force the use of Customer Managed Keys for query. Defaults to true. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_daily_quota_gb"></a> [log\_analytics\_workspace\_daily\_quota\_gb](#input\_log\_analytics\_workspace\_daily\_quota\_gb) | The daily ingestion quota in GB for the Log Analytics Workspace. Default is 1. | `number` | `1` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace where logs should be sent. | `string` | `null` | no |
| <a name="input_log_analytics_workspace_internet_ingestion_enabled"></a> [log\_analytics\_workspace\_internet\_ingestion\_enabled](#input\_log\_analytics\_workspace\_internet\_ingestion\_enabled) | Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_internet_query_enabled"></a> [log\_analytics\_workspace\_internet\_query\_enabled](#input\_log\_analytics\_workspace\_internet\_query\_enabled) | Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_reservation_capacity_in_gb_per_day"></a> [log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day](#input\_log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day) | The daily ingestion quota in GB for the Log Analytics Workspace. Default is 200. | `number` | `200` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_log_enabled"></a> [log\_enabled](#input\_log\_enabled) | Is this Diagnostic Log enabled? Defaults to true. | `string` | `true` | no |
| <a name="input_loganalytics_storage_account_kind"></a> [loganalytics\_storage\_account\_kind](#input\_loganalytics\_storage\_account\_kind) | The Kind of log analytics storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage | `string` | `"StorageV2"` | no |
| <a name="input_loganalytics_storage_account_replication_type"></a> [loganalytics\_storage\_account\_replication\_type](#input\_loganalytics\_storage\_account\_replication\_type) | The Replication Type of log analytics storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string` | `"GRS"` | no |
| <a name="input_loganalytics_storage_account_tier"></a> [loganalytics\_storage\_account\_tier](#input\_loganalytics\_storage\_account\_tier) | The Tier of log analytics storage account to create. Valid options are Standard and Premium. | `string` | `"Standard"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_ops_logging_law_custom_name"></a> [ops\_logging\_law\_custom\_name](#input\_ops\_logging\_law\_custom\_name) | The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_ops_logging_law_sa_custom_name"></a> [ops\_logging\_law\_sa\_custom\_name](#input\_ops\_logging\_law\_sa\_custom\_name) | The name of the custom operational logging laws storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_retention_policy_enabled"></a> [retention\_policy\_enabled](#input\_retention\_policy\_enabled) | Is this Retention Policy enabled? | `bool` | `false` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | The ID of the Storage Account where logs should be sent. | `string` | `null` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_user_assigned_identity_custom_name"></a> [user\_assigned\_identity\_custom\_name](#input\_user\_assigned\_identity\_custom\_name) | The name of the custom user assigned identity to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_automation_account_dsc_server_endpoint"></a> [automation\_account\_dsc\_server\_endpoint](#output\_automation\_account\_dsc\_server\_endpoint) | Automation Account Resource Group Name |
| <a name="output_automation_account_id"></a> [automation\_account\_id](#output\_automation\_account\_id) | Automation Account ID |
| <a name="output_automation_account_identity"></a> [automation\_account\_identity](#output\_automation\_account\_identity) | Automation Account Identity |
| <a name="output_automation_account_name"></a> [automation\_account\_name](#output\_automation\_account\_name) | Automation Account Name |
| <a name="output_laws_name"></a> [laws\_name](#output\_laws\_name) | LAWS Name |
| <a name="output_laws_primary_shared_key"></a> [laws\_primary\_shared\_key](#output\_laws\_primary\_shared\_key) | LAWS Primary Shared Key |
| <a name="output_laws_resource_id"></a> [laws\_resource\_id](#output\_laws\_resource\_id) | LAWS Resource ID |
| <a name="output_laws_rgname"></a> [laws\_rgname](#output\_laws\_rgname) | LAWS Resource Group Name |
| <a name="output_laws_secondary_shared_key"></a> [laws\_secondary\_shared\_key](#output\_laws\_secondary\_shared\_key) | LAWS Primary Shared Key |
| <a name="output_laws_storage_account_id"></a> [laws\_storage\_account\_id](#output\_laws\_storage\_account\_id) | LAWS Storage Account ID |
| <a name="output_laws_storage_account_location"></a> [laws\_storage\_account\_location](#output\_laws\_storage\_account\_location) | LAWS Storage Account Location |
| <a name="output_laws_storage_account_name"></a> [laws\_storage\_account\_name](#output\_laws\_storage\_account\_name) | LAWS Storage Account Name |
| <a name="output_laws_storage_account_rgname"></a> [laws\_storage\_account\_rgname](#output\_laws\_storage\_account\_rgname) | LAWS Storage Account Resource Group Name |
| <a name="output_laws_workspace_id"></a> [laws\_workspace\_id](#output\_laws\_workspace\_id) | LAWS Workspace ID |
<!-- END_TF_DOCS -->
