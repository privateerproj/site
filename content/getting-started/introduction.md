---
title: Introduction to Privateer
type: docs
weight: 1
description: What Privateer is, why it exists, and how a validation run works.
---

**Privateer** checks your systems against published security and compliance standards and writes a report that both people and other tools can read. Instead of proving compliance by hand, with spreadsheets and screenshots, you run one command and get a control-by-control record of what was checked and what was found.

It does this by running automated checks called **plugins**, collecting their results, and writing them out in a structured, machine-readable format.

## Key concepts overview

Privateer is built on several components that work together:

| Component | Role |
| --- | --- |
| **Privateer SDK** | Provides common logic shared by Privateer and all plugins |
| **Privateer Core** (pvtr) | The main executable that runs plugins based on user configuration |
| **Plugin** | Executes validation tests and returns results to Privateer Core |
| **EvaluationSuite** | A set of related data mapping control IDs and requirements to one or more assessment steps |
| **AssessmentStep** | A specialized function that analyzes a data payload provided at runtime |

Unfamiliar with any of these? The [glossary](/getting-started/glossary/) defines each one in plain language.

**Key features:**

* **Community-driven plugins**: crafted and maintained collaboratively by the community, or privately within your organization
* **Comprehensive resource validation**: validate any number of resources against any number of standards in a single run
* **Consistent machine-readable output**: standardized output (YAML, JSON, or SARIF) simplifies automation and integration
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

**Producing evidence that travels.** Privateer writes structured results in YAML, JSON, or SARIF. Pipelines, security dashboards, and GRC platforms can read them without any conversion. Every run produces a timestamped, control-by-control record of what was checked and what the result was.

## How a validation run works

When you run `pvtr run`, here is what happens under the hood:

1. Core reads your `config.yml`, which tells it which services to validate and which plugin to use for each one.
2. For each service, Core locates the corresponding plugin binary in the binaries directory.
3. Core launches the plugin as a separate subprocess and communicates with it over a local gRPC connection. This isolation means a plugin crash cannot bring down the entire run.
4. The plugin connects to its target, for example, the GitHub API, and collects the data it needs.
5. The plugin runs its **EvaluationSuites**, which are groups of related checks. Each individual check is called an **AssessmentStep**, a function that looks at the collected data and returns one of six results: `Passed`, `Failed`, `NeedsReview`, `NotApplicable`, `NotRun`, or `Unknown`. The [glossary](/getting-started/glossary/#results) explains each one.
6. The plugin sends its results back to Core.
7. Core writes the results to your output directory in YAML, JSON, or SARIF format, and exits with a code that reflects whether everything passed.

## What Privateer validates against

Privateer does not invent its own rules. It validates against **control catalogs**, like the OSPS Baseline (Open Source Project Security Baseline) maintained by the OpenSSF, and Common Cloud Controls maintained by FINOS.

## What the output looks like

After a run, Privateer writes results into a directory (default: `evaluation_results/`). For each service, you get a log file and a results file. The results file lists every control that was evaluated, its result, and the specific AssessmentStep messages that explain why.

Results can be written in three formats, which include YAML, JSON and SARIF.
