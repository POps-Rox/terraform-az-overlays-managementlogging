locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name         = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location                    = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  ops_logging_law_name        = coalesce(var.ops_logging_law_custom_name, data.popsrox_utils_resource_name.laws.result)
  ops_logging_law_sa_name     = coalesce(var.ops_logging_law_sa_custom_name, data.popsrox_utils_resource_name.logging_st.result)
  automation_account_name     = coalesce(var.automation_account_custom_name, data.popsrox_utils_resource_name.automation_account.result)
  user_assigned_identity_name = coalesce(var.user_assigned_identity_custom_name, data.popsrox_utils_resource_name.user_assigned_identity.result)
  ampls_subnet_name           = coalesce(var.ampls_subnet_custom_name, data.popsrox_utils_resource_name.ampls_snet.result)
}
