---
title: Your first validation run
type: docs
weight: 4
description: Run a validation against a GitHub repository, step by step.
---

The simplest thing you can do with Privateer is run a validation against a GitHub repository. This is the starting point for every user.

Before you run this, make sure you have:

* Privateer installed (`pvtr version` should return a version string)
* The **openssf/github-repo** plugin installed
* A GitHub personal access token with **read** scope

## Step 1. Install a plugin

Install the OpenSSF GitHub repository scanner ([source](https://github.com/ossf/pvtr-github-repo-scanner)) from grc.store:

```bash
pvtr install openssf/github-repo
```

## Step 2.  Check installed plugins

```bash
pvtr list -a
```

Expected output:

```text
| Plugin                | Version   | Installed  | In Current Config  |
| openssf/github-repo   | 0.33.2    | true       | false              |
```

## Step 3.  Create your config (config.yml)

Once Privateer and the plugin are installed, you will need a config file. The below example is a minimum valid config file:

```yaml
loglevel: Debug
write-directory: my_results
services:
  my-service:
    plugin: your-plugin-binary
    test-suites:
      - default
```

> **Note:** If your config is not in the current directory, use `-c /path/to/config.yml`.

## Step 4. Run

```bash
pvtr run -c config.yml
```

> **Note:** To run a specific service only:
>
> ```bash
> pvtr run -c config.yml -s my-service
> ```
