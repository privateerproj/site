---
title: "Get to Know the SDK"
linkTitle: "Get to Know the SDK"
weight: 20
description: >
  Learn about the Privateer SDK and how to use it in your plugins.
---

## Privateer SDK

<img src="/images/anvil.svg" alt="Privateer SDK" class="doc-float-img">

The Privateer SDK provides the interface and utilities needed for plugin development:

{{< godoc-link package="github.com/privateerproj/privateer-sdk" text="View SDK Documentation" >}}

## What the SDK Provides

1. **Plugin Interface**: Standard gRPC-based interface for plugin communication (HashiCorp go-plugin)
2. **Evaluation Framework**: EvaluationOrchestrator, EvaluationSuite, assessment execution and result aggregation
3. **Configuration Management**: Config loading, validation, and resolution
4. **Registry Client**: HTTP client for the plugin registry at revanite.io/privateer
5. **Manifest Management**: Plugin manifest (plugins.json) tracking installed plugins
6. **Install Utilities**: Plugin download and installation from registry or local paths
7. **Common Utilities**: Logging, error handling, output formatting (YAML, JSON, SARIF)

## Key SDK Components

### Plugin Interface

The SDK provides a standard interface that all plugins must implement. This ensures consistent behavior across all Privateer plugins and allows the Privateer core to orchestrate plugin execution.

### Common Utilities

The SDK includes shared functionality for plugin operations, such as:
- Configuration management
- Logging utilities
- Error handling
- Data processing helpers

### Evaluation Framework

The SDK provides tools for running and managing evaluations:
- EvaluationOrchestrator for catalog matching and suite execution
- EvaluationSuite for individual evaluation execution and summary logging
- Result aggregation across assessments
- Output formatting (YAML, JSON, SARIF)

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
