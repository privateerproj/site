---
title: "Get to Know the SDK"
linkTitle: "Get to Know the SDK"
weight: 20
description: >
  Learn about the Privateer SDK and how to use it in your plugins.
---

## Privateer SDK

<img src="/images/sdk.svg" alt="Privateer SDK" style="float: right; max-width: 120px; margin: 0 0 20px 20px;">

The Privateer SDK provides the interface and utilities needed for plugin development:

{{< godoc-link package="github.com/privateerproj/privateer-sdk" text="View SDK Documentation" >}}

## What the SDK Provides

1. **Plugin Interface**: Standard interface that allows plugins to be called by the Privateer core
2. **Common Logic**: Shared functionality useful for any plugin
3. **Cloud Provider Logic**: Utilities for working with various cloud providers that may benefit multiple plugins
4. **Evaluation Framework**: Tools for running and managing evaluations

## Key SDK Components

### Plugin Interface

The SDK provides a standard interface that all plugins must implement. This ensures consistent behavior across all Privateer plugins and allows the Privateer core to orchestrate plugin execution.

### Common Utilities

The SDK includes shared functionality for plugin operations, such as:
- Configuration management
- Logging utilities
- Error handling
- Data processing helpers

### Cloud Provider Support

The SDK includes logic for working with various cloud providers that can be reused across multiple plugins:
- AWS utilities
- Azure utilities
- GCP utilities
- Common cloud provider patterns

### Evaluation Framework

The SDK provides tools for running and managing evaluations:
- Test execution
- Result aggregation
- Output formatting
- Validation logic

## Privateer Core

The Privateer CLI provides command-line tools for running validation tests. It orchestrates plugin execution and manages configuration.

{{< godoc-link package="github.com/privateerproj/privateer" >}}

### Key Components

- **Command Interface**: CLI commands for running, listing, and managing plugins
- **Configuration Management**: YAML/JSON configuration file support
- **Plugin Orchestration**: Manages plugin lifecycle and execution
- **Output Generation**: Creates standardized log and result files

## Next Steps

- Learn how to [create a new plugin](/docs/developers/plugins/) using the SDK
- Review the [SDK Documentation](https://pkg.go.dev/github.com/privateerproj/privateer-sdk) for detailed API reference
- Explore the [Privateer Core Documentation](https://pkg.go.dev/github.com/privateerproj/privateer) to understand the CLI interface
