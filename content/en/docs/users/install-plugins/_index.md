---
title: "Install Plugins"
linkTitle: "Install Plugins"
weight: 3
description: >
  Learn how to find and install Privateer plugins for infrastructure validation.
---

## Overview

Privateer plugins are community-built tools that validate infrastructure resources according to specific control frameworks and standards. Plugins are distributed as standalone binaries that you install to your Privateer binaries path.

## Finding Plugins

Plugins are built and maintained by the community. You can find available plugins through:

- **Community Repositories**: Check the Privateer community for published plugins
- **GitHub**: Search for Privateer plugins on GitHub
- **FINOS Projects**: Plugins developed for projects like Compliant Financial Infrastructure and Common Cloud Controls

## Installation Methods

### Default Installation Path

By default, Privateer looks for plugins in:

```
$HOME/.privateer/bin
```

### Installing a Plugin

To install a plugin:

1. **Download or build the plugin binary**: Obtain the plugin binary file (e.g., `example`, `raid-wireframe`)

2. **Copy to the binaries path**: Copy the plugin binary to your Privateer binaries directory:

   ```bash
   cp plugin-binary $HOME/.privateer/bin
   ```

   > [!NOTE]
   > If the `$HOME/.privateer/bin` directory doesn't exist, it should have been created during Privateer installation. If it's missing, create it with `mkdir -p $HOME/.privateer/bin` or refer to the [Install Privateer](/docs/users/install-privateer/#post-installation-setup) guide.

3. **Make it executable** (if needed):

   ```bash
   chmod +x $HOME/.privateer/bin/plugin-binary
   ```

### Custom Binaries Path

You can customize where Privateer looks for plugins in two ways:

#### Via Command Line Flag

Use the `--binaries-path` flag when running Privateer:

```bash
privateer run --binaries-path /custom/path/to/binaries
```

#### Via Configuration File

Specify a custom binaries path in your `config.yml`:

```yaml
binaries-path: /custom/path/to/binaries
loglevel: Debug
write-directory: sample_output
services:
  my-cloud-service1:
    plugin: example
    test-suite:
      - tlp_red
```

## Verifying Installation

### Check Installed Plugins

Use the `list` command to see which plugins are installed:

```bash
privateer list
```

This shows plugins requested by your configuration and whether they're installed.

To see all plugins (installed or requested):

```bash
privateer list -a
```

### Verify Plugin Works

After installing a plugin, you can verify it works by:

1. **Including it in your configuration**:

   ```yaml
   services:
     my-service:
       plugin: your-plugin-name
       test-suite:
         - default
   ```

2. **Running Privateer**:

   ```bash
   privateer run -c config.yml
   ```

If the plugin is correctly installed and configured, Privateer will execute it successfully.

## Plugin Requirements

Before installing a plugin, ensure:

- The plugin binary is compatible with your operating system and architecture
- You have the necessary permissions to write to the binaries directory
- The plugin binary has execute permissions
- Any plugin-specific dependencies are installed

## Troubleshooting

### Plugin Not Found

If Privateer can't find your plugin:

1. **Verify the plugin is in the correct path**: Check that the plugin binary is in the directory specified by `--binaries-path` or the default `$HOME/.privateer/bin`

2. **Check the plugin name**: Ensure the plugin name in your `config.yml` matches the binary filename (without the path)

3. **Verify permissions**: Make sure the plugin binary has execute permissions

4. **Use the list command**: Run `privateer list -a` to see what Privateer can detect

### Multiple Plugin Versions

If you need to manage multiple versions of a plugin:

- Use different binary names (e.g., `plugin-v1`, `plugin-v2`)
- Update your configuration to reference the specific version you want to use
- Consider using a version management system or symbolic links

## Next Steps

- Learn how to [configure and run plugins](/docs/users/) in your Privateer setup
- Explore [available plugins](/docs/users/) in the community
- Check out the [Privateer SDK documentation](https://pkg.go.dev/github.com/privateerproj/privateer-sdk) if you want to develop your own plugins

