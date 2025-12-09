---
title: "For Users"
linkTitle: "For Users"
weight: 2
description: >
  Learn how to install and use Privateer to validate your infrastructure resources.
---

## Getting Started with Privateer

This section covers everything you need to know to use Privateer for infrastructure validation.

## Using Privateer Plugins

There are several key benefits to Privateer Plugins:

- **Community-Driven Plugins:** Our open development model ensures that Plugins are crafted and maintained collaboratively by the community, reflecting a wealth of expertise and insights.
- **Comprehensive Resource Validation:** Privateer empowers you to validate a diverse array of resources in a single execution. No more piecemeal validation processes; instead, experience efficiency and thoroughness in one go.
- **Consistent Machine-Readable Output:** Regardless of the specific Plugin, you're guaranteed a standardized, machine-readable test output. This consistency simplifies the automation and integration of test results, enabling seamless decision-making.
- **Empowering Service Providers:** Privateer finds its calling in projects like Compliant Financial Infrastructure and Common Cloud Controls within FINOS. Service providers can leverage Privateer Plugins developed by FINOS to certify resources for use in regulated industries, such as insurance and banking.

## Installation

### Install Privateer CLI

For detailed installation instructions, see [Install Privateer](/docs/users/install-privateer/).

**Quick Reference:**
- **Install via Script**: Use the provided installation script (recommended)
- **Download from Releases**: Get the binary from [GitHub Releases](https://github.com/privateerproj/privateer/releases)
- **Build from Source**: Clone and build from the repository

After installation, verify with `privateer version`.

### Install Privateer Plugins

For detailed instructions on finding and installing plugins, see [Install Plugins](/docs/users/install-plugins/).

**Quick Reference:**
- **Default Path**: `$HOME/.privateer/bin`
- **Customize via CLI**: Use `--binaries-path` in your CLI command to change the path to your binaries
- **Customize via config**: Specify a custom binaries path in your config via the top level value `binaries-path: your/bin/path`

## Quick Start

### 1. Create a Configuration File

For detailed configuration file documentation, see [Configuration File](/docs/users/config-file/).

**Quick Example:**

```yaml
loglevel: Debug
write-directory: sample_output
services:
  my-cloud-service1:
    plugin: example
    test-suite:
      - tlp_red
```

> [!NOTE]
> If your configuration file is stored in a non-default location, specify its file path using the `-c` or `--config` flag.

### 2. Run Privateer

Execute Privateer with your configuration:

```bash
privateer run -c config.yml
```

### 3. Review Results

Privateer generates logs and results files in the output directory:

- **Log Results**: `<write-directory>/<plugin_name>/<plugin_name>.log`
- **Plugin Results**: `<write-directory>/<plugin_name>/results.yaml` (available in both JSON and YAML formats)
- **Default Directory**: `evaluation_results`

## Common Commands

Here are some common commands you can use with Privateer:

- `help` / `-h` / `--help`: Display help information about Privateer and its commands
- `run`: Execute the specified plugin(s)
- `generate-plugin`: Generate a new plugin based on a Gemara Layer 2 schema catalog
- `list`: Show plugins requested by your configuration and whether they're installed
  - `list -a`: Show all plugins that have been installed or requested in the current config
- `version`: Display version details
- `completion`: Generate autocompletion scripts for bash, fish, powershell, or zsh

## Command Line Options

### Global Flags

All commands support these global flags:

- `-b, --binaries-path`: Path to the directory where plugins are installed (default: `$HOME/.privateer/bin`)
- `-c, --config`: Configuration file, JSON or YAML (default: `config.yml`)
- `-h, --help`: Display help information
- `-l, --loglevel`: Log level - trace, debug, info, warn, error, off (default: "error")
- `-s, --service`: Named service to execute from the config
- `--silent`: Only show essential log information
- `-t, --test-suites`: Named set of test sets to execute from the plugin (default: "default")
- `--write`: Keep detailed result outputs in files (default: true)
- `-w, --write-directory`: Directory to write evaluation results to (default: "evaluation_results")

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

