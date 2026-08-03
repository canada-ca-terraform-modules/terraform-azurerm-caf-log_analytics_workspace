## [1.1.0] - 2026-08-03

The format from this entry onward follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

### Changed

- Upgraded `azurerm` provider constraint to `~> 5.0` (created `providers.tf`; none existed before).
- `output.object` is now marked `sensitive = true` (exposes the full `azurerm_log_analytics_workspace`
  resource object).
- Replaced `.terraform-docs.yml` + `doc.md` header-file convention with the org-standard
  `<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->` inject markers directly in `README.md`; static
  description/usage content now lives above the markers.
- Replaced the live-deploy `.github/workflows/test.yml` (required real `ARM_CLIENT_SECRET` /
  `ARM_CLIENT_ID` secrets, applied and destroyed real Azure resources against a `test/` directory
  that no longer exists in this repo) with `.github/workflows/terraform-ci.yml`, which runs
  `fmt`/`init`/`validate`/`test`/`tflint` against `mock_provider`-backed tests — no Azure
  credentials required.
- Bumped `actions/checkout` to `v7.0.1` and `terraform-docs/gh-actions` to `v1.4.1` in
  `.github/workflows/documentation.yml`.
- Fixed `.gitignore`: replaced the stale `test/*` ignore patterns (referencing a directory that no
  longer exists) with the standard template, including `*.tfvars` ignored before the
  `!ESLZ/*.tfvars` negation (previously absent, making that negation a no-op).
- Added trailing newline to `.gitattributes`.

### Added

- `custom_name` optional input to override the auto-generated Log Analytics Workspace name
  (default: `{env4}CLD-{userDefinedString}-{unique}-law`).
- New optional `azurerm_log_analytics_workspace` arguments (azurerm >= 5.x), all additive and
  gated with `try(..., null)`: `local_authentication_enabled`, `allow_resource_only_permissions`,
  `daily_quota_gb`, `cmk_for_query_forced`, `internet_ingestion_access_type`,
  `internet_query_access_type`, `reservation_capacity_in_gb_per_day`, `data_collection_rule_id`,
  `immediate_data_purge_on_30_days_enabled`, `identity`.
- `providers.tf`, `.tflint.hcl` (none previously existed).
- `.github/workflows/terraform-ci.yml` and `.github/workflows/release.yml` (release-on-merge,
  tagged from `ESLZ/log_analytics_workspace.tf`'s own `?ref=`).
- `ESLZ/log_analytics_workspace.tf` (module block, previously absent) and
  `ESLZ/log_analytics_workspace.tfvars` with commented examples for every new argument.
- `tests/log_analytics_workspace.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` (no prior test
  coverage existed).

### Fixed

- Removed `main.tf`'s `data "azurerm_client_config" "current"` — declared but never referenced
  anywhere in the module (dead code, flagged by `tflint`'s `terraform_unused_declarations` rule).

### Known blockers

- None. No module input variables were removed and no resource address changed; existing tfvars
  require no changes. `azurerm_log_analytics_solution` and
  `azurerm_log_analytics_datasource_windows_event` had no schema changes relevant to this module
  between the previous provider version and `5.0.1`.

## v1.0.2 (June 2020)

FEATURES: 
* **new feature:** 

IMPROVEMENTS:

BUGS:
* Adding support for solutions and windows datasources map

## v1.0.1 (June 2020)

FEATURES: 
* **new feature:** 

IMPROVEMENTS:

BUGS:
* Fix issue with original regex implementation for names

## v1.0.0 (June 2020)

FEATURES: 
* **new feature:**  Initial release

IMPROVEMENTS:

BUGS:
