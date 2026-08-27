# `test/live/` - live-test harness

A live, real-Azure-resource harness used by the `live-test` PR check (see
`.github/workflows/live-test.yml`) to prove that an open PR doesn't destroy
or replace a resource a real consumer already has running.

## What's here

| File | Purpose |
|---|---|
| `main.tf` | Module block with `source = "../../"`, the `azurerm` provider config, and an empty `backend "local" {}` block (path supplied at `init` time). |
| `test_dependencies.tf` | A dedicated, throwaway resource group this harness owns outright. Its name is suffixed with `var.pr_number` so concurrently open PRs never collide. |
| `variables.tf` | `env`, `location` (defaults to `canadacentral`), `tags`, `pr_number` (defaults to `"manual"`). |
| `config/log_analytics_workspace.tfvars` | One representative real-usage fixture. |

## Running it manually

Requires your own `az login` session against the sandbox subscription (CI
uses OIDC instead).

```bash
cd test/live
terraform init
terraform plan  -var-file=config/log_analytics_workspace.tfvars
terraform apply -var-file=config/log_analytics_workspace.tfvars
```

Confirm only the live-test resource group and `module.log_analytics_workspace`
are planned/applied, then tear it down:

```bash
terraform destroy -var-file=config/log_analytics_workspace.tfvars
```

No `.tfstate` file is ever committed under `test/live/` - every run is
fully ephemeral, whether run by CI or by hand.

## Two-checkout state isolation (baseline vs. PR)

CI proves a PR isn't a breaking change by applying the target branch as a
live baseline, then plan/apply-ing the PR branch's checkout of this same
harness against that same live state:

```bash
STATE=$RUNNER_TEMP/live-test-<pr-number>.tfstate

# 1. Baseline apply
cd baseline/test/live
terraform init -backend-config="path=$STATE"
terraform apply -var-file=config/log_analytics_workspace.tfvars -var="pr_number=<pr-number>"

# 2. PR plan + apply
cd pr/test/live
terraform init -backend-config="path=$STATE"
terraform plan -var-file=config/log_analytics_workspace.tfvars -var="pr_number=<pr-number>"

# 3. Destroy
terraform destroy -var-file=config/log_analytics_workspace.tfvars -var="pr_number=<pr-number>"
```
