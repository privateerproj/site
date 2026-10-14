---
title: Glossary
type: docs
weight: 7
description: Plain-language definitions of the terms used across the Privateer docs.
---

Click a term to expand its definition.

<details>
<summary>Binary</summary>

A program file you can run directly, already compiled for your operating system. `pvtr` is a binary, and so is each plugin. Installing Privateer means putting these files somewhere your shell can find them.

</details>

<details>
<summary>Plugin</summary>

A separate program that knows how to inspect one kind of system, such as a GitHub repository or a Kubernetes cluster. It gathers data from that system, runs checks against it, and sends the results back to Privateer Core. All validation logic lives in plugins; Core itself checks nothing. You install plugins with `pvtr install`.

</details>

<details>
<summary>Privateer SDK</summary>

A Go library shared by Privateer Core and every plugin. It handles how they talk to each other, how configuration is read, how logs are written and what a result looks like. You only need it if you write a plugin.

</details>

<details>
<summary>Control</summary>

One requirement in a control catalog, with its own ID such as `OSPS-VM-01`. Each control states something a compliant system should do. Privateer reports a result for every control it checks.

</details>

<details>
<summary>Control catalog</summary>

A published list of security or compliance requirements, each with an ID. Examples are the OpenSSF OSPS Baseline and the FINOS Common Cloud Controls. Privateer does not write its own rules; it checks your systems against the controls in a catalog you choose.

</details>

<details>
<summary>Gemara</summary>

An OpenSSF model for governance, risk and compliance (GRC) engineering. It splits compliance work into layers, from writing the rules down to checking real systems against them. Privateer works at the Evaluation layer. See [gemara.openssf.org](https://gemara.openssf.org).

</details>

<details>
<summary>Policy</summary>

The block in your config file that says what to check against. It names one or more control catalogs and an applicability filter. A policy can be set once for all services or separately per service.

</details>

<details>
<summary>Applicability</summary>

A filter inside the policy that selects which controls from a catalog apply to your target. For example, `Maturity Level 1` in the OSPS Baseline selects only the entry-level controls. Controls outside the filter are not evaluated.

</details>

<details>
<summary>Service</summary>

One named entry under `services:` in your config file. It is a single target for Privateer to check, such as one GitHub repository, and says which plugin to run, which test suites to use and what values that plugin needs.

</details>

<details>
<summary>EvaluationSuite</summary>

A group of related checks inside a plugin. It maps control IDs and their requirements from a catalog to the assessment steps that verify them. A plugin may ship several suites; the `test-suites` list in your config picks which ones run.

</details>

<details>
<summary>AssessmentStep</summary>

A single check. It is a function inside a plugin that looks at the data collected from your system and returns a result for one requirement, along with a message explaining why.

</details>

<details id="results">
<summary>Results (Passed, Failed, NeedsReview, NotApplicable, NotRun, Unknown)</summary>

Every control in a report ends with one of six results:

* **Passed**: the requirement was observed to be met.
* **Failed**: the requirement was observed not to be met.
* **NeedsReview**: the data was missing or ambiguous, so a person needs to decide.
* **NotApplicable**: the requirement does not apply to this target.
* **NotRun**: the check was never executed, usually because an earlier step stopped the chain.
* **Unknown**: the check could not run, usually because the collected data was unusable.

</details>

<details>
<summary>Non-zero exit code</summary>

When a command finishes, it hands the shell a number called the exit code. Zero means success. For `pvtr run`, zero means every control passed. Any other number means at least one control was Failed, NeedsReview, or Unknown, or the run itself hit an error such as a missing plugin or an invalid config file. Automated pipelines use this number to decide whether to stop.

</details>

<details>
<summary>YAML</summary>

A plain-text format for structured data that uses indentation instead of brackets. Privateer's config file is YAML, and so is the default results file.

</details>

<details>
<summary>SARIF</summary>

Static Analysis Results Interchange Format, a standard JSON layout for reporting findings. Privateer can write results as SARIF so tools such as the GitHub Security tab can display them without any conversion.

</details>

<details>
<summary>CI/CD</summary>

Continuous integration and continuous delivery: automated pipelines, such as GitHub Actions, that build, test and ship code on every change. Running Privateer in one checks your systems every time something changes, with no manual step.

</details>
