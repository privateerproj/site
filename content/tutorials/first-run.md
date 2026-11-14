---
title: Your first validation run
featured: true
description: Run your first validation test in five minutes.
weight: 1
aliases: [/getting-started/quickstart/, /getting-started/first-run/]
---

This guide helps you run your first validation test. If a term is unfamiliar, the [glossary](/reference/glossary/) defines it. Before you start, make sure you have:

* A terminal: macOS/Linux shell, or **PowerShell on Windows**
* Internet access to download the [binary](#1-install-privateer) and [plugin](#3-install-a-plugin)
* A GitHub personal access token with read scope (for the example below)

## 1. Install Privateer

*macOS / Linux / WSL:*

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/pvtr/main/install.sh)"
```

*Windows:* the script above won't run in PowerShell. Download `pvtr_Windows_x86_64.zip` from the [releases page](https://github.com/privateerproj/pvtr/releases), then run the commands below. They assume the ZIP is in your `Downloads` folder; if not, change the path in the first line. The archive holds `pvtr.exe` at its top level, so it extracts to `$HOME\Downloads\pvtr\pvtr.exe`.

```powershell
Expand-Archive "$HOME\Downloads\pvtr_Windows_x86_64.zip" -DestinationPath "$HOME\Downloads\pvtr" -Force
mkdir $HOME\bin -Force
Move-Item "$HOME\Downloads\pvtr\pvtr.exe" $HOME\bin\
[Environment]::SetEnvironmentVariable("Path",
    [Environment]::GetEnvironmentVariable("Path","User") + ";$HOME\bin", "User")
mkdir $HOME\.privateer\bin -Force
```

Then close and reopen PowerShell.

## 2. Verify

```bash
pvtr version
```

Expected output: a version string such as `0.24.3` (or `edge-dev` for a source build).

If you see `command not found`, the binary isn't on your PATH. On macOS/Linux: `export PATH="$PATH:/usr/local/bin"`. On Windows, confirm the folder you placed `pvtr.exe` in is on your user PATH, then reopen PowerShell.

## 3. Install a plugin

Plugins are an essential component of Privateer as they contain the validation logic. To test how they work you can install the GitHub repo scanner using its full grc.store `<namespace>/<plugin_id>` coordinate:

```bash
pvtr install openssf/github-repo
```

Verify it's detected:

```bash
pvtr list
```

The plugin should appear with `Installed = true`.

## 4. Create a config file (`config.yml`)

```yaml
loglevel: debug
write-directory: sample_output
targets:
  my-github-repo:
    plugin: openssf/github-repo   # the coordinate you installed in step 3
    test-suites:
      - default
    vars:
      owner: my-org      # your GitHub org or username
      repo: my-repo      # your repository name
      # token is read from PVTR_VARS_TOKEN in step 5; keep it out of this file
    policy:
      catalogs:
        - osps-baseline
      applicability:
        - Maturity Level 1
```

## 5. Run

Pass your GitHub token in the `PVTR_VARS_TOKEN` environment variable. This needs pvtr 0.24.3 or later and a plugin built on privateer-sdk v1.35.0 or later; for the GitHub repo scanner that is a release after v0.33.2. The [configuration reference](/reference/configuration/#variables-from-the-environment) explains how environment variables map to plugin vars.

*macOS / Linux:*

```bash
PVTR_VARS_TOKEN=your_github_token pvtr run -c config.yml
```

*Windows (PowerShell):*

```powershell
$env:PVTR_VARS_TOKEN = "your_github_token"
pvtr run -c config.yml
```

An exit code of `0` means every control passed. Anything else means at least one control did not pass, or the run itself hit an error. See [Did it work?](#did-it-work) below, and the [exit code table](/reference/cli/#exit-codes) for each value.

## 6. Review results

Results go in the folder set by `write-directory`, under the target's name ([file locations](/reference/output-schema/#file-locations)):

```text
sample_output/my-github-repo/my-github-repo.log
sample_output/my-github-repo/my-github-repo.yaml
```

### Did it work?

A run can finish successfully and still report failing controls. Read these three signals together:

* **The exit code** tells you whether everything passed. `0` means every control passed. Any other value means at least one control was `Failed`, `NeedsReview`, or `Unknown`, or the run itself hit an error such as a missing plugin or an invalid config file.
* **The log file** (`my-github-repo.log`) confirms the plugin actually ran and shows what it did. Read it first if the run exited with an error or wrote no results file.
* **The results file** (`my-github-repo.yaml`) lists every control that was checked, its result, and a message explaining why.

In short: exit code `0` and a results file means validation passed. A non-zero exit code with a results file means the run worked but some controls need attention. A non-zero exit code and no results file means the run itself did not complete, so start with the log.
