## [1.1.0] - 2026-08-03

The format from this entry onward follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

### Changed

- Upgraded `azurerm` provider constraint to `~> 5.0` (created `providers.tf`; none existed before).
- `output.object` is now marked `sensitive = true` (exposes the full `azurerm_log_analytics_workspace`
  resource object).
- `identity` is now a typed `object({ type = string, identity_ids = optional(list(string)) })` (was
  `any`), with `validation` blocks enforcing `type` is `SystemAssigned`/`UserAssigned` and that
  `identity_ids` is provided and non-empty when `type = "UserAssigned"`.
- `internet_ingestion_access_type` and `internet_query_access_type` gained `validation` blocks
  constraining them to `Enabled`/`Disabled`/`SecuredByPerimeter` so invalid values fail at
  `terraform plan` instead of surfacing as an opaque provider API error.
- Removed redundant `try(var.x, null)` wrappers on the new `azurerm_log_analytics_workspace`
  arguments and the `identity` dynamic block's `for_each` guard — every one of these variables
  already declares `default = null`, so referencing them directly is equivalent and `try()` never
  had an error to catch.
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
- New optional `azurerm_log_analytics_workspace` arguments (azurerm >= 5.x), all additive with
  `default = null` so omitting them keeps the provider's own default and produces no plan diff:
  `local_authentication_enabled`, `allow_resource_only_permissions`, `daily_quota_gb`,
  `cmk_for_query_forced`, `internet_ingestion_access_type`, `internet_query_access_type`,
  `reservation_capacity_in_gb_per_day`, `data_collection_rule_id`,
  `immediate_data_purge_on_30_days_enabled`, `identity`.
- `workspace_id` output — exposes the Log Analytics Workspace GUID (customer ID) without requiring
  callers to unwrap the sensitive `object` output.
- `providers.tf`, `.tflint.hcl` (none previously existed).
- `.github/workflows/terraform-ci.yml` and `.github/workflows/release.yml` (release-on-merge,
  tagged from `ESLZ/log_analytics_workspace.tf`'s own `?ref=`).
- `ESLZ/log_analytics_workspace.tf` (module block, previously absent) and
  `ESLZ/log_analytics_workspace.tfvars` with commented examples for every new argument.
- `tests/log_analytics_workspace.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` (no prior test
  coverage existed; 13 runs total, including `user_assigned_identity` and `workspace_id_output`).

### Fixed

- Removed `main.tf`'s `data "azurerm_client_config" "current"` — declared but never referenced
  anywhere in the module (dead code, flagged by `tflint`'s `terraform_unused_declarations` rule).

### Known blockers

- None. No module input variables were removed and no resource address changed; existing tfvars
  require no changes. `azurerm_log_analytics_solution` and
  `azurerm_log_analytics_datasource_windows_event` had no schema changes relevant to this module
  between the previous provider version and `5.0.1`.
- The automated PR review flagged `release.yml`'s idempotency check (no-op when a release for the
  current `?ref=` already exists) as "silent" when a PR merges without bumping the ref. This is the
  intended behaviour, not a bug — most merges to this repo (docs/CI-only changes) are expected to
  land without a version bump, and the workflow is deliberately designed not to fail or create a
  duplicate/empty release for them (see Artifact 10 in the `eslz-module-upgrade` skill). Left
  unchanged.

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
