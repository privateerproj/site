---
title: Configuration reference
description: Every config key, variable resolution rules, and the policy block.
weight: 2
aliases: [/developer-reference/configuration/]
---

Privateer reads YAML or JSON. It looks for `config.yml` in the current working directory by default.

## Full example

```yaml
# Global settings
loglevel: debug
write-directory: evaluation_results
write: true
output: yaml
binaries-path: $HOME/.privateer/bin
invasive: false

# Global policy: applied to all targets unless overridden at the target level
policy:
  catalogs:
    - osps-baseline
  applicability:
    - Maturity Level 1

# Global variables: available to all targets
vars:
  environment: production
  region: us-east-1

targets:
  my-github-repo:
    plugin: openssf/github-repo    # the installed plugin's grc.store coordinate
    test-suites:
      - default
    loglevel: info                 # overrides global loglevel for this target
    vars:
      owner: my-org
      repo: my-repo
      # token: set PVTR_VARS_TOKEN instead; never commit real values
    policy:
      catalogs:
        - osps-baseline
      applicability:
        - Maturity Level 1
```

## Top-level settings

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `loglevel` | string | `error` | `trace`, `debug`, `info`, `warn`, `error`, `off` |
| `write-directory` | string | `evaluation_results` | Output directory for result files |
| `write` | boolean | `true` | Write result files to disk |
| `output` | string | `yaml` | Results format; see [output formats](/reference/cli/#output-formats) |
| `binaries-path` | string | `$HOME/.privateer/bin` | Plugin binary directory |
| `invasive` | boolean | `false` | Permit plugins to modify infrastructure |
| `policy` | object |  | Global policy; overridable per target |
| `vars` | object |  | Global variables; overridable per target |
| `plugin` | string |  | Global plugin coordinate; used by any target that does not set its own |
| `version` | string |  | Global plugin version pin; used by any target that does not set its own |

## Target settings

Each key under `targets` is a unique target name, matched against the `--target` flag and used to name the [result files](/reference/output-schema/#file-locations).

`services` is the legacy name for `targets` and still works. If a config has both keys, `services` is ignored.

| Key | Type | Required | Description |
| --- | --- | --- | --- |
| `plugin` | string | Yes, unless set globally | The installed plugin's coordinate, as shown by `pvtr list`: `<namespace>/<plugin_id>` from grc.store, or `local/<binary name>` after `pvtr install --local`. A bare name such as `github-repo` is not found |
| `version` | string | No | Plugin version pin; overrides global `version` |
| `test-suites` | array | No | Suites to run (default: `["default"]`) |
| `loglevel` | string | No | Per-target log verbosity override |
| `vars` | object | No | Target-specific variables |
| `policy` | object | No | Target-specific policy; overrides global |
| `invasive` | boolean | No | Per-target invasive override |

## Variable resolution

Each var is resolved from these sources, lowest to highest precedence (the last one set wins):

1. Global `vars` in the config file
2. The target's `vars` in the config file
3. `PVTR_VARS_<KEY>`
4. `PVTR_SERVICES_<TARGET>_VARS_<KEY>` (only when the config uses the legacy `services` key)
5. `PVTR_TARGETS_<TARGET>_VARS_<KEY>`

Nothing substitutes placeholders such as `{{TOKEN}}`; a value in the file is passed to the plugin as written.

### Variables from the environment

`<KEY>` and `<TARGET>` are upper-cased, with hyphens and dots turned into underscores: var `api-key` on target `my-repo` is `PVTR_TARGETS_MY_REPO_VARS_API_KEY`. A var set this way does not need to appear in the file at all, so keep secrets out of the config and set them in the environment:

```bash
PVTR_VARS_TOKEN="$MY_SECRET_TOKEN" pvtr run -c config.yml
```

The plugin, not pvtr, reads these variables. It needs pvtr 0.24.3 or later and a plugin built on privateer-sdk v1.35.0 or later; for the GitHub repo scanner that is a release after v0.33.2. An older plugin ignores them and reports the var as missing (exit code `3`).

## Policy

```yaml
policy:
  catalogs:
    - osps-baseline       # control catalog ID
  applicability:
    - Maturity Level 1    # applicability tier filter
```

Policy is required for every target: after fallback, both `catalogs` and `applicability` must be non-empty, or the plugin rejects the config at startup and `pvtr run` exits `3`. Each field falls back independently: a target that sets only `catalogs` still inherits the global `applicability`, and vice versa. Within a field, the target value fully replaces the global list; lists are never merged. A catalog the plugin does not provide stops the run with exit code `4`. An applicability value the plugin does not recognise is not an error: every requirement is reported `Not Applicable` and the run exits `0`,, so check the plugin's documentation for its exact values.

## invasive flag

When `invasive: false` (the default), Core signals plugins that they must not modify infrastructure. Whether a plugin respects this signal depends on the plugin implementation, so read plugin documentation before enabling `invasive: true`. Most community plugins are read-only and ignore the flag entirely.
