---
title: "Getting Started with Privateer"
linkTitle: "For Users"
weight: 2
description: >
  Learn how to install and use Privateer to validate your infrastructure resources.
---

## Prerequisites

### Install Privateer CLI

For detailed installation instructions, see [Install Privateer](/docs/users/install-privateer/).

**Quick Reference:**
- **Homebrew (macOS)**: `brew install privateerproj/tap/pvtr`
- **Install via Script**: Use the provided installation script (recommended for Linux)
- **Download from Releases**: Get the binary from [GitHub Releases](https://github.com/privateerproj/privateer/releases)
- **Build from Source**: Clone and build from the repository

After installation, verify with `pvtr version`.

### Install Privateer Plugins

For detailed instructions on finding and installing plugins, see [Install Plugins](/docs/users/install-plugins/).

**Quick Reference:**
- **Default Path**: `$HOME/.privateer/bin`
- **Customize via CLI**: Use `--binaries-path` in your CLI command to change the path to your binaries
- **Customize via config**: Specify a custom binaries path in your config via the top level value `binaries-path: your/bin/path`

## Quick Start

### 1. Create a Configuration File

Save a `config.yml` file in your working directory. For detailed configuration options, see [Configuration File](/docs/users/config-file/).

**Quick Example:**

```yaml
loglevel: Debug
write-directory: sample_output
services:
  myStorageService:
    plugin: privateerproj/example
    policy:
      catalogs:
        - <catalog-id>
      applicability:
        - <maturity-level>
  myComputeService:
    plugin: privateerproj/example
    policy:
      catalogs:
        - <catalog-id>
      applicability:
        - <maturity-level>
```

_**NOTE:** If your configuration file is stored in a non-default location, specify its file path using the `-c` or `--config` flag._

### 2. Run Privateer

Run all services defined in your configuration:

```bash
pvtr run
```

Or run a single service by name:

```bash
pvtr run --service myStorageService
```

### 3. Review Results

Privateer generates logs and results files in the output directory (default `./evaluation_results/`):

- **Log Results**: `<write-directory>/<plugin_name>/<plugin_name>.log`
- **Plugin Results**: `<write-directory>/<plugin_name>/results.yaml` (available in both JSON and YAML formats)

## Common Commands

Here are some common commands you can use with Privateer:

- `help` / `-h` / `--help`: Display help information about Privateer and its commands
- `run`: Execute the specified plugin(s)
- `env` (alias `info`): Display runtime environment details (binary path, config, plugins, version, build info)
- `install <owner/repo>`: Install a vetted plugin from the registry
- `generate-plugin`: Generate a new plugin based on a Gemara Layer 2 schema catalog
- `list`: Show plugins requested by your configuration and whether they're installed
  - `list -a`: Show all plugins that have been installed or requested in the current config
  - `list --installed`: Show only installed plugins
  - `list --installable`: Show only plugins available for installation
- `version`: Display version details (use `-v` for verbose output including commit hash and build time)
- `completion`: Generate autocompletion scripts for bash, fish, powershell, or zsh

### Log Levels

Control logging verbosity with the `-l, --loglevel` flag:

- **trace**: Most verbose, shows all debug information
- **debug**: Debug information
- **info**: General information
- **warn**: Warning messages
- **error**: Error messages only (default)
- **off**: No logging

Use `--silent` to show only essential log information regardless of log level.

## Next Steps

- Learn how to [develop plugins](/docs/developers/) if you want to extend Privateer
- Check out the [Privateer SDK documentation](https://pkg.go.dev/github.com/privateerproj/privateer-sdk) for advanced usage

