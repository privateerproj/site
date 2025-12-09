---
title: "Create a New Plugin"
linkTitle: "Create a New Plugin"
weight: 10
description: >
  Learn how to create and maintain Privateer plugins.
---

## Generating a Plugin

<img src="/images/plugin.svg" alt="Plugin" style="float: right; max-width: 120px; margin: 0 0 20px 20px;">

Privateer includes a command to generate a plugin from a YAML controls catalog document that complies with the [Gemara](https://gemara.openssf.org) Layer 2 schema.

To start without a catalog instead, you can simply clone the [example plugin](https://github.com/privateerproj/plugin-example) and adjust it to your needs.

### Getting Started

1. **Get a catalog file**: You can use any Gemara Layer 2 catalog, such as recent releases from the [Common Cloud Controls](https://github.com/finos/common-cloud-controls/releases) project.

2. **Generate the plugin**: In the root of your workspace, run the following command:

```bash
privateer generate-plugin \
    --source-path ~/path/to/catalog.yaml \
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

### Building the Generated Plugin

After generating a plugin, you need to build it:

1. **Navigate to the generated plugin directory**:

   ```bash
   cd generated-plugin
   ```

2. **Copy the example configuration**:

   ```bash
   cp config-example.yml config.yml
   ```

3. **Build the plugin**:

   ```bash
   make binary
   ```

After building, see [Debug a Plugin](/docs/developers/run-debug-mode/) for instructions on running your plugin.

## Plugin Structure

A typical Privateer plugin includes the following components, organized hierarchically:

<div style="display: flex; flex-wrap: wrap; gap: 20px; margin: 20px 0; align-items: center;">
  <div style="text-align: center;">
    <img src="/images/plugin.svg" alt="Plugin" width="100">
    <p><strong>Plugin</strong></p>
  </div>
  <div style="text-align: center;">
    <img src="/images/testSuite.svg" alt="EvaluationSuite" width="100">
    <p><strong>EvaluationSuite</strong></p>
  </div>
  <div style="text-align: center;">
    <img src="/images/testSet.svg" alt="Test Set" width="100">
    <p><strong>Test Set</strong></p>
  </div>
  <div style="text-align: center;">
    <img src="/images/test.svg" alt="Test" width="100">
    <p><strong>Test</strong></p>
  </div>
</div>

A typical Privateer plugin includes:

- **Main Entry Point**: Plugin initialization and execution
- **Data Collection**: Logic to gather infrastructure data
- **Evaluation Plans**: Test suites and validation logic
- **Configuration**: Plugin-specific configuration options
- **Documentation**: README and usage instructions

## Plugin Installation

Once developed, plugins need to be installed before they can be used. For detailed installation instructions, see [Install Plugins](/docs/users/install-plugins/) in the users documentation.

## Contributing Plugins

We welcome contributions! To contribute a plugin:

1. Develop your plugin using the Privateer SDK
2. Test thoroughly with various configurations
3. Create comprehensive documentation
4. Submit a pull request or share via the community

## Next Steps

- Review the [Get to Know the SDK](/docs/developers/sdk/) to understand the plugin interface
- Learn how to [debug your plugin](/docs/developers/run-debug-mode/) during development
- Check out the [raid-wireframe example plugin](https://github.com/privateerproj/raid-wireframe) for a complete reference implementation
