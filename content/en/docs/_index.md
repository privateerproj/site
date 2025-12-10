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

- **Community-Driven Plugins**: Plugins are crafted and maintained collaboratively by the community
- **Comprehensive Resource Validation**: Validate diverse resources in a single execution
- **Consistent Machine-Readable Output**: Standardized output simplifies automation and integration
- **Empowering Service Providers**: Certify resources for use in regulated industries

Privateer is built on several key concepts that work together to provide comprehensive validation:

|   |   |   |
|---|---|---|
| <img src="/images/anvil.svg" alt="anvil" width="100"> | Privateer SDK | provides common logic for Privateer and Plugins |
| <img src="/images/ship.svg" alt="ship" width="100" height="100"> | Privateer Core | the main executable that runs plugins based on user configuration |
| <img src="/images/map.svg" alt="map" width="100"> | Plugin | execute validation tests and return results to Privateer |
| <img src="/images/cannon.svg" alt="cannon" width="100"> | EvaluationSuite | a set of related data allowing control IDs and their requirements to be mapped to one or more assessment steps |
| <img src="/images/match.svg" alt="match" width="100"> | AssessmentStep | a specialized function which will analyze a data payload provided at runtime |
