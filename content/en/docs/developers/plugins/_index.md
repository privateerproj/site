---
title: "Create a New Plugin"
linkTitle: "Create a New Plugin"
weight: 10
description: >
  Learn how to create and maintain Privateer plugins.
---

## Getting Started with Plugin Development

### Prerequisites

- Go 1.19 or later

## Generating a Plugin

Privateer includes a command to generate a plugin from a YAML controls catalog document that complies with the [Gemara](https://gemara.openssf.org) Layer 2 schema:

```bash
privateer generate-plugin \
  --source-path catalog.yaml \
  --service-name "MyService" \
  --output-dir my-plugin/
```

This generates a complete plugin structure based on the catalog, including placeholders for data collection, evaluation plans, and assessments.

The generated catalog may still have non-functional values which you will need to update before it can compile.

### Command Options

The `generate-plugin` command accepts the following options:

- `-p, --source-path`: The source file to generate the plugin from
- `-n, --service-name`: The name of the service (e.g. 'ECS', 'AKS', 'GCS')
- `-o, --output-dir`: Output directory for the generated plugin (default: "generated-plugin/")
- `--local-templates`: Path to local templates instead of downloading latest

## Plugin Structure

A typical Privateer plugin includes:

- **Main Entry Point**: Plugin initialization and execution
- **Data Collection**: Logic to gather infrastructure data
- **Evaluation Plans**: Test suites and validation logic
- **Configuration**: Plugin-specific configuration options
- **Documentation**: README and usage instructions

## Plugin Installation

Once developed, plugins can be installed to the Privateer binaries path:

- **Default Path**: `$HOME/.privateer/bin`
- **Custom Path**: Specify via `--binaries-path` flag or config file

## Example Plugin

For an example of a complete plugin implementation, see the [raid-wireframe](https://github.com/privateerproj/raid-wireframe) plugin, which serves as a reference implementation.

## Contributing Plugins

We welcome contributions! To contribute a plugin:

1. Develop your plugin using the Privateer SDK
2. Test thoroughly with various configurations
3. Create comprehensive documentation
4. Submit a pull request or share via the community

## Resources

- [Privateer SDK Documentation](https://pkg.go.dev/github.com/privateerproj/privateer-sdk)
- [Get to Know the SDK](/docs/developers/sdk/)
- [Example Plugin: raid-wireframe](https://github.com/privateerproj/raid-wireframe)

## Next Steps

- Review the [Get to Know the SDK](/docs/developers/sdk/) to understand the plugin interface
- Check out example plugins in the community
- Start building your first plugin!
