mock_provider "azurerm" {}
mock_provider "popsrox" {}

variables {
  location           = "eastus"
  environment        = "public"
  deploy_environment = "dev"
  workload_name      = "opslog"
  org_name           = "anoa"
  enable_telemetry   = false
}

override_data {
  target = data.popsrox_resource_name.logging_st
  values = {
    result = "generatedst"
  }
}

override_data {
  target = data.popsrox_resource_name.laws
  values = {
    result = "generated-law"
  }
}

override_data {
  target = data.popsrox_resource_name.automation_account
  values = {
    result = "generated-aa"
  }
}

override_data {
  target = data.popsrox_resource_name.user_assigned_identity
  values = {
    result = "generated-uai"
  }
}

override_data {
  target = data.popsrox_resource_name.ampls_snet
  values = {
    result = "generated-snet"
  }
}

override_data {
  target = data.azurerm_client_config.current
  values = {
    object_id       = "00000000-0000-0000-0000-000000000001"
    client_id       = "00000000-0000-0000-0000-000000000002"
    tenant_id       = "00000000-0000-0000-0000-000000000003"
    subscription_id = "00000000-0000-0000-0000-000000000004"
  }
}

override_data {
  target = data.azurerm_resource_group.rgrp[0]
  values = {
    name     = "existing-rg"
    location = "westus2"
  }
}

override_module {
  target = module.mod_azure_region_lookup
  outputs = {
    location_cli   = "eastus"
    location_short = "eus"
  }
}

override_module {
  target = module.mod_scaffold_rg
  outputs = {
    resource_group_name     = "created-rg"
    resource_group_location = "eastus"
  }
}

override_module {
  target = module.mod_loganalytics_sa
  outputs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000004/resourceGroups/created-rg/providers/Microsoft.Storage/storageAccounts/generatedst"
  }
}

override_module {
  target  = module.mod_log_diagnostic_settings
  outputs = {}
}

override_module {
  target  = module.mod_aa_diagnostic_settings
  outputs = {}
}

override_module {
  target = module.lz_management_resources
  outputs = {
    log_analytics_workspace = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000004/resourceGroups/created-rg/providers/Microsoft.OperationalInsights/workspaces/generated-law"
      name         = "generated-law"
      workspace_id = "workspace-guid"
    }
    log_analytics_workspace_keys = {
      primary   = "primary-key"
      secondary = "secondary-key"
    }
    automation_account = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000004/resourceGroups/created-rg/providers/Microsoft.Automation/automationAccounts/generated-aa"
      name                = "generated-aa"
      dsc_server_endpoint = "https://example.test/dsc"
      identity            = []
    }
  }
}

run "custom_names_override_generated_names" {
  command = apply

  variables {
    create_resource_group                            = true
    ops_logging_law_sa_custom_name                   = "customst"
    automation_account_custom_name                   = "custom-aa"
    user_assigned_identity_custom_name               = "custom-uai"
    enable_automation_account_user_assigned_identity = true
  }

  assert {
    condition     = output.laws_storage_account_name == "customst"
    error_message = "The storage account custom name must override the generated name."
  }

  assert {
    condition     = output.automation_account_name == "custom-aa"
    error_message = "The automation account custom name must override the generated name."
  }

  assert {
    condition     = azurerm_user_assigned_identity.management[0].name == "custom-uai"
    error_message = "The user-assigned identity custom name must override the generated name."
  }
}

run "empty_custom_names_fall_through_to_generated_names" {
  command = apply

  variables {
    create_resource_group                            = true
    ops_logging_law_sa_custom_name                   = ""
    automation_account_custom_name                   = ""
    user_assigned_identity_custom_name               = ""
    enable_automation_account_user_assigned_identity = true
  }

  assert {
    condition     = output.laws_storage_account_name == "generatedst"
    error_message = "An empty storage account custom name must fall through to the generated name."
  }

  assert {
    condition     = output.automation_account_name == "generated-aa"
    error_message = "An empty automation account custom name must fall through to the generated name."
  }

  assert {
    condition     = azurerm_user_assigned_identity.management[0].name == "generated-uai"
    error_message = "An empty user-assigned identity custom name must fall through to the generated name."
  }
}

run "user_assigned_identity_enabled_count" {
  command = apply

  variables {
    create_resource_group                            = true
    enable_linked_automation_account_creation        = true
    enable_automation_account_user_assigned_identity = true
  }

  assert {
    condition     = length(azurerm_user_assigned_identity.management) == 1
    error_message = "One user-assigned identity must be planned when linked automation account creation and user-assigned identity are enabled."
  }
}

run "user_assigned_identity_disabled_count" {
  command = apply

  variables {
    create_resource_group                            = true
    enable_linked_automation_account_creation        = true
    enable_automation_account_user_assigned_identity = false
  }

  assert {
    condition     = length(azurerm_user_assigned_identity.management) == 0
    error_message = "No user-assigned identity must be planned when user-assigned identity is disabled."
  }
}

run "user_assigned_identity_disabled_when_automation_account_disabled" {
  command = apply

  variables {
    create_resource_group                            = true
    enable_linked_automation_account_creation        = false
    enable_automation_account_user_assigned_identity = true
  }

  assert {
    condition     = length(azurerm_user_assigned_identity.management) == 0
    error_message = "No user-assigned identity must be planned when linked automation account creation is disabled."
  }
}

run "tags_merge_defaults_and_overrides" {
  command = apply

  variables {
    create_resource_group = true
    add_tags = {
      env      = "override-dev"
      costCode = "cc123"
    }
  }

  assert {
    condition = (
      local.common_tags.deployedBy == "AzureNoOpsTF [default]" &&
      local.common_tags.env == "override-dev" &&
      local.common_tags.workload == "opslog" &&
      local.common_tags.costCode == "cc123"
    )
    error_message = "Custom tags must merge over default tags while preserving defaults not overridden."
  }
}

run "created_resource_group_location_passthrough" {
  command = apply

  variables {
    create_resource_group = true
  }

  assert {
    condition     = output.laws_storage_account_location == "eastus"
    error_message = "When creating the resource group, the module must pass through the created resource group's location."
  }
}

run "existing_resource_group_location_passthrough" {
  command = apply

  variables {
    create_resource_group        = false
    existing_resource_group_name = "existing-rg"
  }

  assert {
    condition     = output.laws_storage_account_location == "westus2"
    error_message = "When using an existing resource group, the module must pass through the existing resource group's location."
  }
}
