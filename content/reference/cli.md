---
title: CLI reference
description: Every pvtr subcommand, its flags, and usage examples.
weight: 1
aliases: [/developer-reference/cli-reference/]
---

The Privateer CLI is the `pvtr` binary. Every subcommand accepts the global flags below, plus its own options.

## Global flags

| Flag | Short | Default | Description |
| --- | --- | --- | --- |
| `--binaries-path` | `-b` | `$HOME/.privateer/bin` | Directory where plugins are installed and resolved |
| `--config` | `-c` | `./config.yml`, then `~/.privateer/config.yml` | Config file path (JSON or YAML) |
| `--loglevel` | `-l` | `error` | Verbosity: `trace`, `debug`, `info`, `warn`, `error`, `off` |
| `--autoinstall` |  | `false` | Before a run, install any plugin the config requests that is not yet installed |
| `--hub-url` |  | `https://hub.grc.store` | grc.store hub base URL; the registry host is discovered from it |
| `--help` | `-h` |  | Show help |

## pvtr run

Resolves each target's plugin from the binaries path, launches it as a gRPC subprocess, collects results, and writes output. Registers handlers for SIGINT and SIGTERM; an interrupted run exits with the abort code, distinct from a validation failure.

```bash
pvtr run
pvtr run -c config.yml
pvtr run -c config.yml --target my-target   # single target
pvtr run --loglevel debug -w ./results -o json
```

| Flag | Short | Default | Description |
| --- | --- | --- | --- |
| `--target` | `-s`, `--service` | (all targets) | Run a single named target from the config. `-s` and `--service` are legacy aliases |
| `--test-suites` | `-t` | `default` | Named test suite(s) to execute |
| `--output` | `-o` | `yaml` | Results format; see [output formats](#output-formats) |
| `--write` |  | `true` | Write result files to disk |
| `--write-directory` | `-w` | `evaluation_results` | Output directory for result files |
| `--include-payload` |  | `false` | Include the raw evaluated payload in the results (large; useful for tracing) |
| `--concurrency` |  | `1` | Plugins to run in parallel; `0` means one per CPU |
| `--silent` |  | `false` | Suppress all non-essential terminal output |

### Output formats

| Value | Results file | Contents |
| --- | --- | --- |
| `yaml` (default) | `<target>.yaml` | Privateer results with one Gemara Evaluation Log per suite |
| `json` | `<target>.json` | Same as `yaml`, as JSON |
| `sarif` | `<target>.sarif` | SARIF 2.1.0, for the GitHub Security tab |
| `gemara` | `<target>.yaml` | A list of native Gemara Evaluation Logs |

File locations and structure are in the [output schema](/reference/output-schema/).

### Exit codes

| Code | Meaning |
| --- | --- |
| 0 | Everything passed |
| 1 | The run completed and at least one suite is `Failed`, `Needs Review` or `Unknown` |
| 2 | Aborted (signal) |
| 3 | Internal error in pvtr or the plugin, including a plugin that rejects its config (for example a missing variable or policy) |
| 4 | Bad config or flags, including a policy catalog the plugin does not provide |
| 5 | No assessments ran, for example a config that requests no plugins |

A run over several plugins exits with the most severe code among them. An applicability value the plugin does not recognise is not caught: every requirement is `Not Applicable` and the run exits `0` (see [policy](/reference/configuration/#policy)). `1` is a successful run from the plugin's point of view; read the log, not just the code.

## pvtr install

Pulls a plugin from [grc.store](https://hub.grc.store) as a signed OCI artifact, verifies its signature, signer identity and digests, and only then writes it to the binaries path. Takes the plugin's `<namespace>/<plugin_id>` coordinate, optionally pinned with `@<version>` (default: latest). A bare name without a namespace is rejected. The coordinate is also the value of `plugin` in the [config](/reference/configuration/#target-settings).

```bash
pvtr install openssf/github-repo
pvtr install openssf/github-repo@0.33.2
pvtr install openssf/github-repo --binaries-path /opt/pvtr-plugins
pvtr install --local ./my-plugin       # installs as local/my-plugin
pvtr install --from-config -c config.yml
```

| Flag | Description |
| --- | --- |
| `--local <path>` | Install a local plugin binary. It is installed as `local/<binary name>` |
| `--from-config` | Install every plugin the active config references that is not yet installed |

`openssf/github-repo` is the GitHub repo scanner's coordinate; `ossf/pvtr-github-repo-scanner` is its source repository, not something `pvtr install` accepts.

A plugin that declares its control catalogs as grc.store coordinates (via `AddCatalogs` in the SDK) has each catalog fetched, signature-verified, and cached under the binaries path at install time, at `<binaries-path>/catalogs/<namespace>/<id>/<version>.yaml`. `pvtr run` reads that cache and never contacts grc.store, so once a plugin is installed no further network access to grc.store is required. A published catalog version is immutable, so a cached file is never re-fetched. Plugins may instead continue to vendor their catalogs in the binary (via `AddReferenceCatalogs`); those need no catalog cache at all.

## pvtr list

Reports plugins, whether each is installed, and whether the current config requests it.

```bash
pvtr list                # installed, plus any requested by the config
pvtr list --installed    # installed only, with versions
pvtr list -a             # also plugins published on grc.store
pvtr list --installable  # published on grc.store and not yet installed
```

`-a`/`--all`, `--installed` and `--installable` are mutually exclusive. Run `pvtr list --installed` after `pvtr install --local` to confirm Core can discover the plugin.

## pvtr env

Prints a full snapshot of the runtime environment. Useful for debugging environment mismatches in CI.

```bash
pvtr env    # also accessible as: pvtr info
```

Output includes: binary path, config file path and whether it was found, plugins directory, discovered plugin names, version, commit hash, build time, Go version, and OS/architecture.

## pvtr version

```bash
pvtr version            # prints version string only, e.g. 0.1.0
pvtr version --verbose  # adds git commit hash and build timestamp
```

A version of `edge` means the binary was built from source without a release tag. Do not use edge builds in production pipelines.

## pvtr generate-plugin

Generates a plugin scaffold from a Gemara Layer 2 YAML control catalog. The output is a compilable Go module with placeholder implementations for data collection, evaluation plans, and assessment steps.

```bash
pvtr generate-plugin \
  --source-path ~/path/to/catalog.yaml \
  --service-name "MyService" \
  --organization "my-github-org" \
  --output-dir my-plugin/
```

| Flag | Short | Default | Description |
| --- | --- | --- | --- |
| `--source-path` | `-p` |  | Path to the Gemara Layer 2 catalog YAML |
| `--service-name` | `-n` |  | Service name used in generated identifiers |
| `--organization` | `-g` |  | GitHub organization for the plugin module path |
| `--output-dir` | `-o` | `generated-plugin/` | Output directory |
| `--local-templates` |  |  | Use a local templates directory instead of fetching latest |

The generated plugin compiles as emitted, with every requirement bound to a `NotImplemented` placeholder step. See [Build your first plugin](/how-to/build-a-plugin/).

### Generated layout

```text
my-plugin/
  main.go                          # orchestrator wiring; Publisher and License are set here
  go.mod                           # pins privateer-sdk and go-gemara; no go.sum, so run go mod tidy first
  data/
    data_collection.go             # Payload and Loader
    catalogs/catalog_<id>_<ver>.yaml  # the source catalog, vendored in the binary
  evaluation_plans/
    evaluation_plans.go            # TypedStep, and Suite_<id>: requirement id -> step chain
    reusable_steps/steps.go        # NotImplemented placeholder
  example-config.yml
  Makefile
  README.md
  TESTING.md
  .gitignore
  .goreleaser.yaml                 # release build; pvtr publish reads its dist directory
  .github/workflows/               # build, lint, CodeQL, release, and grc.store publish workflows
```

Running `generate-plugin` over an existing plugin overwrites every file.

## pvtr completion

Generates shell autocompletion scripts.

```bash
pvtr completion bash
pvtr completion zsh
pvtr completion fish
pvtr completion powershell
pvtr completion --help    # shell-specific install instructions
```
