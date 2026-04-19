---
title: "Configuration File"
linkTitle: "Configuration File"
weight: 4
description: >
  Learn how to configure Privateer using YAML or JSON configuration files.
---

## Overview

Privateer uses configuration files to specify which plugins to run, how to run them, and what settings to apply. Configuration files can be written in YAML or JSON format, with YAML being the most commonly used.

## File Location

When Privateer needs a configuration file, it uses the following fallback chain:

1. **Explicit flag** — If `--config` / `-c` is provided, that exact path is used.
2. **Current directory** — Otherwise, Privateer looks for `./config.yml` in the working directory.
3. **Home directory** — If no file is found in the current directory, it falls back to `~/.privateer/config.yml`.

### When to use each approach

If you want a configuration that is picked up automatically from any directory, place it at `~/.privateer/config.yml`. This is useful for situations where you'd like to call pvtr from any working directory.

If you are making iterative development, or need to override the global settings create a `config.yml` in the current working directory. This take precedence over the home-directory copy.

If you are using a config file that has a unique name, such as `dev-config.yml`. or it is located in another working directory outside of your present location, 

## Configuration Structure

A Privateer configuration file has two main sections:

1. **Top-level settings**: Global configuration that applies to all services
2. **Services section**: Service-specific configuration for each plugin you want to run

## Top-Level Configuration

### Global Settings

These settings apply globally but can be overridden at the service level:

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `loglevel` | string | `error` | Log verbosity: `trace` > `debug` > `info` > `warn` > `error` > `off` |
| `write-directory` | string | `evaluation_results` | Directory where results and logs are written |
| `write` | boolean | `true` | Whether to write output files (does not disable log files) |
| `output` | string | `yaml` | Output format: `yaml`, `json`, or `sarif` |
| `binaries-path` | string | `$HOME/.privateer/bin` | Path to directory containing plugin binaries |
| `silent` | boolean | `false` | Only show essential log information |
| `test-suites` | string | `default` | Named set of test suites to execute from the plugin |
| `invasive` | boolean | `false` | Whether plugins are allowed to make changes to infrastructure |

### Policy Settings

Policy settings can be set at the top level to apply to all services, or at the service level:

```yaml
policy:
  catalogs:
    - "catalog-id-1"
    - "catalog-id-2"
  applicability:
    - "category1"
    - "category2"
```

| Setting | Type | Required | Description |
|---------|------|----------|-------------|
| `policy.catalogs` | array | Yes* | List of one or more control catalog IDs to use |
| `policy.applicability` | array | Yes* | List of one or more applicability categories from the selected catalogs |

\* Required when running via Privateer (not in debug mode)

### Global Variables

You can define variables at the top level that will be available to all services:

```yaml
vars:
  global_var1: value1
  global_var2: value2
```

Service-specific variables will override global variables with the same name.

## Services Configuration

The `services` section defines which plugins to run and how to configure them. Each service entry has a unique name that identifies the service being evaluated.

### Service Entry Structure

```yaml
services:
  my-service-name:
    plugin: owner/repo
    loglevel: debug  # Optional: overrides global loglevel
    policy:          # Optional: service-specific policy
      catalogs:
        - "catalog-id"
      applicability:
        - "category1"
    vars:            # Optional: service-specific variables
      var1: value1
```

### Service Settings

| Setting | Type | Required | Description |
|---------|------|----------|-------------|
| `plugin` | string | Yes | Plugin identifier in `owner/repo` format |
| `loglevel` | string | No | Override global log level for this service |
| `vars` | object | No | Service-specific variables |
| `policy` | object | No | Service-specific policy configuration |
| `invasive` | boolean | No | Override global invasive setting |

## Complete Example

Here's a complete example configuration file:

```yaml
# Global settings
loglevel: debug
write-directory: sample_output
write: true
output: yaml
binaries-path: $HOME/.privateer/bin

# Global policy (applies to all services if not overridden)
policy:
  catalogs:
    - "common-cloud-controls-v1"
  applicability:
    - "compute"
    - "storage"

# Global variables (available to all services)
vars:
  environment: production
  region: us-east-1

# Services configuration
services:
  # First service
  my-cloud-service1:
    plugin: privateerproj/example
    policy:
      catalogs:
        - "tlp-red"
        - "tlp-amber"
    vars:
      service_name: my-cloud-service1
      custom_setting: value1

  # Second service (can use a different plugin)
  my-cloud-service2:
    plugin: privateerproj/raid-wireframe
    loglevel: info  # Override global log level
    vars:
      service_name: my-cloud-service2
      different_setting: value2
```

## Minimal Example

A minimal configuration file only requires the `services` section:

```yaml
services:
  my-service:
    plugin: privateerproj/example
    policy:
      catalogs:
        - "default"
```

All other settings will use their default values.

## Running Specific Services

When you have multiple services defined, you can run a specific service using the `-s` or `--service` flag:

```bash
pvtr run -c config.yml -s my-cloud-service1
```

If you don't specify a service, Privateer will run all services defined in the configuration.

## Variable Resolution

Variables are resolved in the following order (later values override earlier ones):

1. Global variables (top-level `vars`)
2. Service-specific variables (`services.<service-name>.vars`)

Service-specific variables take precedence over global variables with the same name.

## Policy Resolution

Policy settings follow the same resolution pattern:

1. Global policy (top-level `policy`)
2. Service-specific policy (`services.<service-name>.policy`)

Service-specific policy settings override global policy settings.

## Output Files

When `write: true` (the default), Privateer generates the following files for each service:

- **Log file**: `<write-directory>/<service-name>/<service-name>.log`
- **Results file**: `<write-directory>/<service-name>/results.<format>` (format is `yaml`, `json`, or `sarif` based on the `output` setting)

## Best Practices

1. **Use meaningful service names**: Service names should be unique and descriptive, as they're used in output file paths and logs.

2. **Organize with comments**: Use YAML comments to document your configuration:
   ```yaml
   services:
     # Production environment services
     prod-service-1:
       plugin: example
   ```

3. **Share common settings**: Use global settings for values that apply to all services, and override only when necessary.

4. **Version control carefully**: Be cautious about committing configuration files with secrets. Consider using environment variables or secret management tools.

5. **Test incrementally**: Start with a minimal configuration and add complexity as needed.

## Advanced Configuration

### Environment Variables

Privateer supports reading configuration from environment variables. Environment variables are automatically merged with your configuration file, with environment variables taking precedence.

### Multiple Configuration Files

You can use different configuration files for different environments:

```bash
# Development
pvtr run -c config.dev.yml

# Production
pvtr run -c config.prod.yml
```

### Future: External Configuration

Privateer's roadmap includes plans for integrating with external configuration management systems like etcd and Consul for enhanced configuration and secret management.

## Troubleshooting

### Configuration Not Found

If Privateer can't find your configuration file:

- Remember the search order: `--config` flag first, then `./config.yml`, then `~/.privateer/config.yml`. Make sure your file is in one of these locations.
- Use the `-c` flag to specify the full path if the file is elsewhere.
- Ensure the file has the correct extension (`.yml`, `.yaml`, or `.json`).

### Invalid Configuration

If you get configuration errors:

- Validate your YAML/JSON syntax
- Check that required fields are present
- Verify that plugin names match installed binaries
- Ensure test suite names are valid for the plugin

### Variables Not Resolved

If variables aren't working as expected:

- Check variable names for typos
- Verify variable scope (global vs. service-specific)
- Ensure variables are defined before they're used

## Next Steps

- Learn how to [run Privateer](/docs/users/#quick-start) with your configuration
- Explore [available plugins](/docs/users/install-plugins/) to use in your configuration
- Check plugin-specific documentation for required variables and test suites

