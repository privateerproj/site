---
title: "Install Plugins"
linkTitle: "Install Plugins"
weight: 3
description: >
  Learn how to find and install Privateer plugins for infrastructure validation.
---

## Overview

Privateer plugins are community-built tools that validate infrastructure resources according to specific control frameworks and standards. Plugins are distributed as standalone binaries that you install to your Privateer binaries path.

The fastest way to get a plugin is with `pvtr install`, which fetches a vetted binary from the Privateer registry. You can also copy a binary into place manually if you prefer.

## Installing a Plugin

### From the Registry (Recommended)

Use `pvtr install` to download a vetted plugin binary from the registry in one step:

```bash
pvtr install <owner/repo>
```

For example:

```bash
pvtr install privateerproj/raid-wireframe
```

If the plugin lives under the `privateerproj` organization, you can use the bare name:

```bash
pvtr install raid-wireframe
```

The command resolves the plugin name against the registry, downloads the correct binary for your platform, and places it in your binaries path (`$HOME/.privateer/bin` by default).

### Manual Installation

If you have a plugin binary from another source—your own build, a colleague, or an external download—you can install it by hand:

1. **Copy the binary to the binaries path**:

   ```bash
   cp plugin-binary $HOME/.privateer/bin
   ```

2. **Make it executable** (if needed):

   ```bash
   chmod +x $HOME/.privateer/bin/plugin-binary
   ```

_**NOTE:** If the `$HOME/.privateer/bin` directory doesn't exist, it should have been created during Privateer installation. If it's missing, create it with `mkdir -p $HOME/.privateer/bin` or refer to the [Install Privateer](/docs/users/install-privateer/#post-installation-setup) guide._

## Custom Binaries Path

You can customize where Privateer looks for plugins in two ways:

### Via Command Line Flag

Use the `--binaries-path` flag when running Privateer:

```bash
pvtr install raid-wireframe --binaries-path /custom/path/to/binaries
pvtr run --binaries-path /custom/path/to/binaries
```

_**NOTE:** Both `pvtr install` and `pvtr run` must use the same binaries path for a plugin to be found at run time._

### Via Configuration File

Specify a custom binaries path in your `config.yml`:

```yaml
binaries-path: /custom/path/to/binaries
loglevel: Debug
write-directory: sample_output
services:
  my-cloud-service1:
    plugin: example
    policy:
      catalogs:
        - tlp_red
```

## Listing Plugins

Use the `list` command to see what plugins are available and what state they're in.

### Plugins from Current Config

Running `pvtr list` with no flags shows the plugins referenced by your current configuration and whether each one is installed:

```bash
pvtr list
```

### All Known Plugins

The `-a` (or `--all`) flag combines installed, configured, and registry plugins into a single view:

```bash
pvtr list -a
```

### Only Installed Plugins

Show just the plugins that are present on disk:

```bash
pvtr list --installed
```

### Installable Plugins

Show vetted plugins from the registry that are available to install:

```bash
pvtr list --installable
```

_**NOTE:** The `-a`, `--installed`, and `--installable` flags are mutually exclusive._

## Verifying a Plugin Works

After installing a plugin, verify it by including it in your configuration and running Privateer:

1. **Add the plugin to your configuration**:

   ```yaml
   services:
     my-service:
       plugin: your-plugin-name
       policy:
         catalogs:
           - default
   ```

2. **Run Privateer**:

   ```bash
   pvtr run -c config.yml
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

4. **Use the list command**: Run `pvtr list -a` to see what Privateer can detect

### Multiple Plugin Versions

If you need to manage multiple versions of a plugin:

- Use different binary names (e.g., `plugin-v1`, `plugin-v2`)
- Update your configuration to reference the specific version you want to use
- Consider using a version management system or symbolic links

## Next Steps

- Learn how to [configure and run plugins](/docs/users/) in your Privateer setup
- Explore [available plugins](/docs/users/) in the community
- Check out the [Privateer SDK documentation](https://pkg.go.dev/github.com/privateerproj/privateer-sdk) if you want to develop your own plugins
