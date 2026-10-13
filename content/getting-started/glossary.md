---
title: Glossary
type: docs
weight: 7
description: Plain-language definitions of the terms used across the Privateer docs.
---

Click a term to expand its definition.

<details>
<summary>Plugin</summary>

A separate program that knows how to inspect one kind of system, such as a GitHub repository or a Kubernetes cluster. It gathers data from that system, runs checks against it, and sends the results back to Privateer Core. All validation logic lives in plugins; Core itself checks nothing. You install plugins with `pvtr install`.

</details>

<details>
<summary>Control catalog</summary>

A published list of security or compliance requirements, each with an ID. Examples are the OpenSSF OSPS Baseline and the FINOS Common Cloud Controls. Privateer does not write its own rules; it checks your systems against the controls in a catalog you choose.

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
<summary>SARIF</summary>

Static Analysis Results Interchange Format, a standard JSON layout for reporting findings. Privateer can write results as SARIF so tools such as the GitHub Security tab can display them without any conversion.

</details>
