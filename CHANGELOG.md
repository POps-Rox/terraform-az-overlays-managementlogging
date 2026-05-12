# v1.0.0 - <date>

## [v2.1.0] - 2026-05-12

### Breaking changes

* Migrated the underlying logging stack from the deprecated `Azure/alz-management/azurerm`
  (`~> 0.1`) module to `Azure/avm-ptn-alz-management/azurerm` (`~> 0.9`). The new AVM
  pattern module has a partially different input/output schema. Notable consumer-visible
  changes:
  * **Outputs** — `laws_primary_shared_key` and `laws_secondary_shared_key` are now sourced
    from the module's `log_analytics_workspace_keys` sensitive output and are marked
    `sensitive = true` on this module. Consumers that previously referenced them in
    non-sensitive contexts must add `sensitive = true` to their downstream outputs.
  * **Outputs** — `automation_account_identity` now exposes the curated
    `{ tenant_id, principal_id }` shape from the AVM module instead of the raw
    `azurerm_automation_account.identity` list. Consumers indexing `identity[0]` must
    update to access fields directly.
  * **Inputs** — `automation_account_encryption.key_vault_url` is no longer supported by
    the AVM module and is not forwarded. `var.automation_account_key_vault_url` is
    retained for backwards compatibility but is now unused; it will be removed in a future
    major release.
  * **Sentinel onboarding** — `enable_sentinel = true` no longer deploys the deprecated
    `SecurityInsights` Log Analytics solution. It now provisions Sentinel via the AVM
    module's `sentinel_onboarding` object (Microsoft.SecurityInsights/onboardingStates).
    The `SecurityInsights` entry in `local.log_analytics_solutions` is filtered out before
    being passed to the module.

### Added

* `enable_telemetry` input (default `true`) forwarded to the AVM pattern module. See
  <https://aka.ms/avm/telemetryinfo>.

### Notes

* Closes #26.
* No state migration is required if you are deploying greenfield. For existing
  deployments, expect the `SecurityInsights` solution plan to be replaced by a Sentinel
  onboarding resource and review the plan before applying.

## [v2.0.0] - 2026-05-11

### Breaking changes

* Upgraded to `azurerm` provider `~> 4.20`. Consumers must set `ARM_SUBSCRIPTION_ID` (azurerm 4.x makes `subscription_id` required for the `azurerm` provider).
* Raised Terraform CLI floor from `>= 1.9` to `>= 1.10`.
* Added `azure/azapi ~> 2.0` to `required_providers` for fleet alignment (not directly referenced today).

### Notes

* No direct `azurerm_*` resources in this module — all Azure resources are created via sibling overlays (`-resourcegroup`, `-storageaccount`, `-diagnosticsettings`). No resource-attribute renames or `retention_policy` removals were needed in this repo. The `var.retention_policy_enabled` module variable is just an input passed to a downstream module.
* `popsrox` local provider name retained.


Added
- Add Something you added
