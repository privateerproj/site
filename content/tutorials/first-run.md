---
title: Your first validation run
featured: true
description: Install Privateer, check one of your GitHub repositories against the OSPS Baseline, and read the result for one control.
weight: 1
aliases: [/getting-started/quickstart/, /getting-started/first-run/]
---

In this tutorial you will install Privateer, use it to check one of your GitHub repositories against the [OSPS Baseline](https://baseline.openssf.org/), and read what it found for one control. If a term is unfamiliar, the [glossary](/reference/glossary/) defines it.

You need:

* A macOS or Linux terminal. On Windows, use WSL.
* A GitHub repository you own, and a [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) that can read it.

## 1. Install Privateer

Run the install script:

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/pvtr/main/install.sh)"
```

Then check that `pvtr` is on your path:

```bash
pvtr version
```

You should see a version number, such as:

```text
0.24.3
```

This tutorial needs 0.24.3 or later.

## 2. Install the GitHub repo scanner

Privateer runs its checks through plugins. Install the one that checks GitHub repositories:

```bash
pvtr install openssf/github-repo
```

The output includes a line like this one. Warning lines about catalogs may follow it; the plugin carries its own copy, so you can ignore them.

```text
Successfully installed openssf/github-repo:<version> (signed by keyless:https://token.actions.githubusercontent.com#https://github.com/ossf/pvtr-github-repo-scanner/.github/workflows/publish-plugin.yaml)
```

Now list your plugins:

```bash
pvtr list
```

You should see the scanner, with `Installed` set to `true`:

```text
| Plugin                | Version   | Installed  | In Current Config  |
| openssf/github-repo   | <version> | true       | false              |
```

The version must be later than 0.33.2, so that the plugin can read your token from the environment in step 4.

## 3. Write the config file

Make a new folder and move into it:

```bash
mkdir first-run && cd first-run
```

Create a file named `config.yml` with this content. Replace `my-org` with your GitHub user or organization name, and `my-repo` with your repository's name.

```yaml
write-directory: results
targets:
  my-repo:
    plugin: openssf/github-repo
    vars:
      owner: my-org
      repo: my-repo
    policy:
      catalogs:
        - osps-baseline
      applicability:
        - Maturity Level 1
```

The file has no token in it. You will pass the token in the next step, so it never lands in a file.

## 4. Run the check

Run `pvtr`, passing your token in the `PVTR_VARS_TOKEN` environment variable:

```bash
PVTR_VARS_TOKEN=your_github_token pvtr run -c config.yml
```

The run takes a few seconds. `pvtr` prints a line for each requirement that failed, then a summary line. Your numbers will differ:

```text
2026-11-13T20:34:16.206-0600 [ERROR] OSPS-BR-07.01: GitHub reports secret scanning and push protection are both disabled
...
2026-11-13T20:34:16.207-0600 [ERROR] > my-repo_osps-baseline: 9 Passed, 26 Warnings, 6 Failed, 41 Possible
```

The `[ERROR]` label marks a failed requirement in your repository, not a problem with the run.

## 5. Open the results

Privateer wrote two files, in a folder named after the target:

```bash
ls results/my-repo
```

```text
my-repo.log  my-repo.yaml
```

Open `results/my-repo/my-repo.yaml` in your editor. Near the top you will see the plugin that ran and the overall result for the catalog:

```yaml
service-name: my-repo
plugin-name: github-repo
...
evaluation-suites:
- name: my-repo_osps-baseline
  result: Failed
  catalog-id: osps-baseline
```

## 6. Read one control

Search the file for `OSPS-AC-01`. This control asks that the repository require multi-factor authentication for sensitive actions. GitHub enforces that for every repository, so this result is the same for everyone:

```yaml
    - name: |
        Use MFA for Sensitive Actions
      result: Passed
      message: This control is enforced by GitHub for all projects
      control:
        reference-id: osps-baseline
        entry-id: OSPS-AC-01
```

Every control in the file has the same shape: a `name`, a `result`, a `message` that says why, and the `entry-id` of the control in the catalog. Below each control, `assessment-logs` holds one entry per requirement, with the steps that ran.

Now search for `result: Failed`. Each match is a control or requirement your repository does not meet yet, and its `message` says what Privateer saw. You will also see `Not Applicable`, and possibly `Needs Review` or `Not Run`.

## What you did

You installed Privateer and a plugin, pointed the plugin at a repository with a config file, ran a check against the OSPS Baseline, and read the result for a control.

Next:

* [Run Privateer in GitHub Actions](/how-to/run-in-github-actions/) to check your repository on every change.
* [Output schema](/reference/output-schema/) explains every field in the results file and what each result value means.
* [Troubleshooting](/how-to/troubleshoot/) covers runs that write no results or exit with an error.
* [Introduction to Privateer](/explanation/introduction/) explains how plugins, the CLI and control catalogs fit together.
