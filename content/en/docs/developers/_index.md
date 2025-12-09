---
title: "For Developers"
linkTitle: "For Developers"
weight: 3
description: >
  Learn how to develop plugins and use the Privateer SDK.
---

## Welcome, Developers

<img src="/images/patches-small.png" alt="Patches the Privateer Pointer" style="float: right; max-width: 120px; margin: 0 0 20px 20px;">

This page orients you to the developer documentation. Start here, then dive into the SDK and plugin guides.

## Plugin Development Overview

Privateer plugins are community-driven validation modules that can be developed and maintained independently. Plugins use the Privateer SDK to integrate with the core framework.

### Why Develop Plugins?

- **Extend Functionality**: Add support for new cloud providers, services, or validation rules
- **Community Contribution**: Share your validation logic with the community
- **Standardized Interface**: Use the SDK to ensure consistent behavior across plugins
- **Reusable Logic**: Leverage common utilities and cloud provider logic from the SDK

## What you'll need

- **Go 1.19 or later** - Required for plugin development
- Access to the infrastructure or services you want to validate
- A working Privateer CLI (see [For Users](/docs/users/) if you need to install)

## Where to go next

- **[Get to Know the SDK](/docs/developers/sdk/)**: Learn the Privateer SDK interfaces, utilities, and core components
- **[Create a New Plugin](/docs/developers/plugins/)**: Generate, build, and ship plugins using the SDK

## Quick Links

- [Privateer SDK on pkg.go.dev](https://pkg.go.dev/github.com/privateerproj/privateer-sdk)
- [Privateer Core on pkg.go.dev](https://pkg.go.dev/github.com/privateerproj/privateer)
- [Example Plugin: raid-wireframe](https://github.com/privateerproj/raid-wireframe)
