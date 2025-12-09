---
title: "For Users"
linkTitle: "For Users"
weight: 2
description: >
  Learn how to install and use Privateer to validate your infrastructure resources.
---

## Getting Started with Privateer

This section covers everything you need to know to use Privateer for infrastructure validation.

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

Plugins are built and maintained by the community. Choose the plugin(s) that you wish to run, and install them to your binaries path.

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

### 2. Run Privateer

Execute Privateer with your configuration:

```bash
privateer run -c config.yml
```

### 3. Review Results

Privateer generates logs and results files in the output directory:

- **Log Results**: `<write-directory>/<plugin_name>/<plugin_name>.log`
- **Plugin Results**: `<write-directory>/<plugin_name>/results.yaml`
- **Default Directory**: `evaluation_results`

## Common Commands

Here are some common commands you can use with Privateer:

- `privateer run`: Execute the specified plugin(s)
- `privateer list`: Show plugins requested by your configuration and whether they're installed
- `privateer list -a`: Show all plugins that have been installed or requested
- `privateer version`: Display version details
- `privateer help`: Display help information

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

