---
title: Output schema
description: File locations, the results file structure, result values, and SARIF.
weight: 3
aliases: [/developer-reference/output-schema/]
---

## File locations

For each target, Core writes two files:

```text
<write-directory>/
  <target>/
    <target>.log      # execution log
    <target>.yaml     # results; .json or .sarif when output is json or sarif
```

`<write-directory>` defaults to `evaluation_results`. `<target>` is the target's name under `targets:` in the config. The `gemara` output format also writes `<target>.yaml`. The output formats are listed in the [CLI reference](/reference/cli/#output-formats).

## Results file structure

With `output: yaml` (the default) or `output: json`, the results file has one entry per evaluation suite. Each suite carries a Gemara Evaluation Log under `control-evaluations`. Abridged JSON from a run of the GitHub repo scanner:

```json
{
  "service-name": "my-github-repo",
  "plugin-name": "github-repo",
  "plugin-uri": "https://github.com/ossf/pvtr-github-repo-scanner",
  "plugin-version": "0.33.2",
  "evaluation-suites": [
    {
      "name": "my-github-repo_osps-baseline",
      "result": "Failed",
      "catalog-id": "osps-baseline",
      "control-evaluations": {
        "metadata": { "type": "EvaluationLog", "gemara-version": "v1.5.0" },
        "result": "Failed",
        "evaluations": [
          {
            "name": "Secure Secrets and Credentials",
            "result": "Failed",
            "message": "GitHub reports secret scanning and push protection are both disabled",
            "control": { "reference-id": "osps-baseline", "entry-id": "OSPS-BR-07" },
            "assessment-logs": [
              {
                "requirement": { "reference-id": "osps-baseline", "entry-id": "OSPS-BR-07.01" },
                "result": "Failed",
                "message": "GitHub reports secret scanning and push protection are both disabled",
                "applicability": ["maturity-1", "maturity-2", "maturity-3"],
                "steps-executed": 1
              }
            ]
          }
        ]
      }
    }
  ]
}
```

With `output: gemara`, the file is a YAML list of the Gemara Evaluation Logs alone, without the Privateer wrapper.

## Result values

Suites, controls and requirements each carry one of the six Gemara results. The file spells them as shown here:

| Value | Go name | Meaning | Halts a step chain |
| --- | --- | --- | --- |
| `Passed` | `gemara.Passed` | The requirement was checked and met | no |
| `Failed` | `gemara.Failed` | The requirement was checked and not met | yes |
| `Needs Review` | `gemara.NeedsReview` | The check could not decide: the data was absent or ambiguous, or only a heuristic could judge it; a person has to look | no |
| `Not Applicable` | `gemara.NotApplicable` | The requirement does not apply under the selected applicability, or to this target | yes |
| `Not Run` | `gemara.NotRun` | The check was skipped; plugin authors use it only for placeholders | no |
| `Unknown` | `gemara.Unknown` | The check could not run, or no step was defined for the requirement; from a step, almost always a loader bug | no |

The Go name is what a plugin's assessment step returns. A requirement's steps
run in order and stop at the first `Failed` or `Not Applicable`; every other
result is folded into the requirement's result and the next step runs.

A suite with any `Failed`, `Needs Review` or `Unknown` result makes `pvtr run` exit `1`; see [exit codes](/reference/cli/#exit-codes).

## SARIF output

With `output: sarif`, Core writes a SARIF 2.1.0 file. Each assessed requirement appears as a result whose `ruleId` is the requirement ID (for example `OSPS-BR-07.01`); failed requirements have `level: error`. The file works with the GitHub Security tab and any SARIF 2.1.0 consumer.
