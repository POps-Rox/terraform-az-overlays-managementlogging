# v1.0.0 - <date>

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
