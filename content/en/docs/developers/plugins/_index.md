---
title: "Create a New Plugin"
linkTitle: "Create a New Plugin"
weight: 10
description: >
  Learn how to create and maintain Privateer plugins.
---

## Generating a Plugin

Privateer includes a command to generate a plugin from a YAML controls catalog document that complies with the [Gemara](https://gemara.openssf.org) Layer 2 schema. This allows you to not have to start from scratch on a new plugin.

> [!NOTE]
> Currently the generator supports YAML files that comply with the Gemara Layer 2 schema. This file is needed to be used to setup the plugin's test suite and test sets. All that is needed to be done after that is writing the actual tests.

### Getting Started

1. **Get a catalog file**: You can use a catalog file like `CCC.VPC_2025.01.yaml` from the [Common Cloud Controls Repository Releases page](https://github.com/finos/common-cloud-controls/releases).

   > [!NOTE]
   > Version may change or you may need to expand the `Assets` section to find the latest yaml file.

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

### Running the Generated Plugin

#### Running in Debug Mode

To run the plugin by itself in debug mode:

```bash
./example debug --service my-cloud-service1
```

> [!TIP]
> If you use a different service name, make sure the service name matches what is in the config.yml in the root of the repository.

> [!IMPORTANT]
> The `test_output/[service_name]` folder should include a log file and a yaml file for each test suite.
>
> Example: `test_output/my-cloud-service1/my-cloud-service1.log` and `test_output/my-cloud-service1/tlp_red.yml`

#### Running from Privateer

To run the plugin from Privateer:

1. **Copy the plugin binary to the Privateer binaries path**:

   ```bash
   cp example $HOME/.privateer/bin
   ```

2. **Copy the configuration to the parent directory**:

   ```bash
   cp config.yml ../
   cd ..
   ```

3. **Run Privateer**:

   ```bash
   privateer run
   ```

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
