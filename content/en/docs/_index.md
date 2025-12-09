---
title: "Documentation"
linkTitle: "Documentation"
weight: 1
description: >
  Complete documentation for the Privateer validation framework.
---

## What is Privateer?

<img src="/images/patches-small.png" alt="Patches the Privateer Pointer" style="float: right; max-width: 150px; margin: 0 0 20px 20px;">

Privateer is a validation framework that simplifies infrastructure testing and compliance validation. Built with infrastructure engineers in mind, Privateer helps you validate resources against regulations, taxonomies, and standards.

## Key Concepts

Privateer is built on several key concepts that work together to provide comprehensive validation:

| Concept | Description | Icon |
|---------|-------------|------|
| **Privateer Core** | An executable test harness that calls plugins based on the user's configuration | <img src="/images/patches-small.png" alt="Privateer Core" width="80"> |
| **Privateer SDK** | A set of logic and tools used to establish efficient, secure, and cohesive collaboration between Privateer and its Plugins | <img src="/images/sdk.svg" alt="SDK" width="80"> |
| **Plugin** | Responsible for executing validation tests and returning results to Privateer | <img src="/images/plugin.svg" alt="Plugin" width="80"> |
| **EvaluationSuite** | Maps to control catalogs, following the "Simplified Compliance Infrastructure" model | <img src="/images/testSuite.svg" alt="Test Suite" width="80"> |
| **Test Set** | A collection of related tests within an EvaluationSuite | <img src="/images/testSet.svg" alt="Test Set" width="80"> |
| **Test** | Individual validation test within a Test Set | <img src="/images/test.svg" alt="Test" width="80"> |

## Key Features

- **Community-Driven Plugins**: Plugins are crafted and maintained collaboratively by the community
- **Comprehensive Resource Validation**: Validate diverse resources in a single execution
- **Consistent Machine-Readable Output**: Standardized output simplifies automation and integration
- **Empowering Service Providers**: Certify resources for use in regulated industries

## Documentation Sections

### [For Users](/docs/users/)
Learn how to install and use Privateer to validate your infrastructure resources.

### [For Developers](/docs/developers/)
Learn how to develop plugins and use the Privateer SDK.
