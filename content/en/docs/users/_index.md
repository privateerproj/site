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

### Install the Privateer CLI

There are several ways to install Privateer:

#### Option 1: Install via Script

Run the following command to install Privateer using the provided install script:

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/privateer/03ced90caae9f3c9203eb7f82f2c46ccf2ff15fc/install.sh)"
```

#### Option 2: Download from Releases

Download the latest release from [GitHub Releases](https://github.com/privateerproj/privateer/releases).

#### Option 3: Build from Source

To build Privateer from source:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/privateerproj/privateer.git
   cd privateer
   ```

2. **Install Dependencies**

   ```bash
   go mod tidy
   ```

3. **Build Privateer**

   ```bash
   make release
   ```

### Install Privateer Plugins

For detailed instructions on finding and installing plugins, see [Install Plugins](/docs/users/install-plugins/).

**Quick Reference:**
- **Default Path**: `$HOME/.privateer/bin`
- **Customize via CLI**: Use `--binaries-path` in your CLI command to change the path to your binaries
- **Customize via config**: Specify a custom binaries path in your config via the top level value `binaries-path: your/bin/path`

### Verify Installation

After installation, verify that Privateer is working correctly:

```bash
privateer version
```

You should see version information displayed.

## Quick Start

### 1. Create a Configuration File

Create a configuration file (e.g., `config.yml`) that specifies the plugins you want to run:

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

### Advanced Config Management

Privateer's roadmap includes plans for integrating with systems like etcd and Consul to enhance configuration and secret management.

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

