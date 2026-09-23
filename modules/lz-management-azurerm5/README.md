# Vendored ALZ management module for azurerm 5.x

This directory vendors `Azure/avm-ptn-alz-management/azurerm` from upstream
repository `Azure/terraform-azurerm-avm-ptn-alz-management`, version `v0.9.0`.
It exists because upstream `v0.9.0` constrains `azurerm` to 4.x, which is
incompatible with this module's root provider constraint of `>= 5.0, < 6.0`.

The upstream module is redistributed under the upstream MIT License, Copyright
(c) Microsoft Corporation. The upstream `LICENSE` file is retained unchanged in
this directory. This copy has been modified by POps-Rox.

## Changes from upstream v0.9.0

The following list was produced by diffing this vendored tree against
`Azure/terraform-azurerm-avm-ptn-alz-management` tag `v0.9.0`.

1. `terraform.tf`
   - `terraform.required_version`: upstream `>= 1.9, < 2.0` → vendored `>= 1.10`, matching this repository's Terraform baseline.
   - `required_providers.azapi.version`: upstream `~> 2.4` → vendored `~> 2.12`.
   - `required_providers.azurerm.version`: upstream `~> 4.35` → vendored `>= 5.0, < 6.0`.

2. `main.tf`, resource `azurerm_log_analytics_workspace.management`
   - `internet_ingestion_enabled = var.log_analytics_workspace_internet_ingestion_enabled` → `internet_ingestion_access_type = var.log_analytics_workspace_internet_ingestion_enabled ? "Enabled" : "Disabled"`.
   - `internet_query_enabled = var.log_analytics_workspace_internet_query_enabled` → `internet_query_access_type = var.log_analytics_workspace_internet_query_enabled ? "Enabled" : "Disabled"`.

3. Vendored packaging
   - Retained the upstream Terraform source files required by this module and the upstream `LICENSE`.
   - Omitted upstream ancillary repository files that are not used by this vendored module: upstream `.github/`, `.devcontainer/`, examples, tests, generated documentation fragments, support/contribution docs, and helper scripts.
   - Replaced the upstream module README with this provenance-focused README.
   - Added `NOTICE` documenting upstream source, version, retrieval date, license, and POps-Rox modifications.

No other Terraform source changes were made relative to upstream `v0.9.0`.

## Maintenance

This vendored copy receives no Dependabot coverage. Upstream changes must be
tracked manually.

Tracking issue: [POps-Rox/.github#27](https://github.com/POps-Rox/.github/issues/27).
Delete this vendored copy and return to the registry module source once upstream
supports azurerm 5.x.
