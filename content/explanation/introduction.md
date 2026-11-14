---
title: Introduction to Privateer
description: What Privateer is, why it exists, and how a validation run works.
weight: 2
aliases: [/getting-started/introduction/]
---

**TL;DR:** New to all of this? [See Privateer and the projects around it in pictures](/tldr/).

**Privateer** checks your systems against published security and compliance standards and writes a report that both people and other tools can read. Instead of proving compliance by hand, with spreadsheets and screenshots, you run one command and get a control-by-control record of what was checked and what was found.

It does this by running automated checks called **plugins**, collecting their results, and writing them out in a structured, machine-readable format.

The terms used on this page, such as plugin, control catalog and EvaluationSuite, are defined in plain language in the [glossary](/reference/glossary/).

**Key features:**

* **Community-driven plugins**: crafted and maintained collaboratively by the community, or privately within your organization
* **Comprehensive resource validation**: validate any number of resources against any number of standards in a single run
* **Consistent machine-readable output**: standardized output in [several formats](/reference/cli/#output-formats), including SARIF and native Gemara Evaluation Logs, simplifies automation and integration
* **Plugin generation**: generate plugin scaffolding from [Gemara](https://gemara.openssf.org/) Layer 2 schema catalogs with a single command

## How Privateer is structured

Privateer has three parts. If you picture a ship's inspection, each part has a clear job.

**Privateer Core (`pvtr`)** is the program you install and run. It is the captain: it reads your orders (the configuration file), decides which specialists to send out, collects what they bring back, and writes up the report. The captain does no inspecting personally. Core contains no validation logic of its own.

**Plugins** do the inspecting. Each plugin is a specialist who knows one kind of system, such as a GitHub repository, an AWS account, or a Kubernetes cluster. It connects to that system, gathers the facts, runs its checks against them, and hands the results back to Core. Plugins are built and shared separately from Core, so anyone can write one without waiting for a change to the main project.

**The Privateer SDK** is the shared rulebook that Core and every plugin follow. It defines how the captain and the specialists talk to each other, how configuration is read, how logs are written, and what a result looks like. Plugin authors import it into their own Go project so their plugin speaks the same language as Core.

![Illustrated overview of how Privateer Core, plugins, and the SDK fit together](/architecture-overview.png)
*Fig 1. Illustrated Overview: How the Pieces Fit Together*

## Why Privateer exists

Most compliance processes break down at the same point: the gap between what a policy *says* and what a system *actually does*. A control catalog can define hundreds of requirements with precision, but verifying them against live infrastructure has traditionally meant manual checks, one-off scripts, or expensive tooling that organizations build and maintain themselves.

Privateer exists to close that gap, addressing three specific problems:

**Turning written controls into runnable checks.** Standards like the [FINOS Common Cloud Controls](https://ccc.finos.org/) and the [OpenSSF OSPS Baseline](https://baseline.openssf.org/) describe what a compliant system looks like. Privateer gives you the tooling to turn those descriptions into automated checks that run against real infrastructure.

**Fitting into the Gemara model.** Privateer operates at the [Evaluation layer](https://gemara.openssf.org/model/07.2-Layer-5) of the Gemara GRC engineering model. You can generate plugin scaffolding directly from a Gemara Layer 2 control catalog, run it, and emit results as standardized Gemara Evaluation Logs.

**Producing evidence that travels.** Privateer writes structured results in [machine-readable formats](/reference/cli/#output-formats), including native Gemara Evaluation Logs. Pipelines, security dashboards, and GRC platforms can read them without any conversion. Every run produces a timestamped, control-by-control record of what was checked and what the result was.

## How a validation run works

When you run `pvtr run`, here is what happens under the hood:

1. Core reads your `config.yml`, which tells it which targets to validate and which plugin to use for each one.
2. For each target, Core locates the corresponding plugin binary in the binaries directory.
3. Core launches the plugin as a separate subprocess and communicates with it over a local gRPC connection. This isolation means a plugin crash cannot bring down the entire run.
4. The plugin connects to its target, for example, the GitHub API, and collects the data it needs.
5. The plugin runs its **EvaluationSuites**, which are groups of related checks. Each individual check is called an **AssessmentStep**, a function that looks at the collected data and returns one of six [results](/reference/output-schema/#result-values), such as `Passed` or `Failed`.
6. The plugin sends its results back to Core.
7. Core writes the results to your output directory in the [format you choose](/reference/cli/#output-formats), and exits with a [code](/reference/cli/#exit-codes) that reflects whether everything passed.

## What Privateer validates against

Privateer does not invent its own rules. It validates against **control catalogs**, like the OSPS Baseline (Open Source Project Security Baseline) maintained by the OpenSSF, and Common Cloud Controls maintained by FINOS.

## What the output looks like

After a run, Privateer writes a log file and a results file for each target. The results file is a control-by-control record: every control that was evaluated, its result, and the messages from the AssessmentSteps that explain why. The [output schema](/reference/output-schema/) describes where the files go and what they contain, and [Your first validation run](/tutorials/first-run/) walks through reading one.
