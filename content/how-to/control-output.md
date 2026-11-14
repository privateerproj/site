---
title: Controlling output
description: Choose the results format and keep terminal output quiet.
weight: 3
aliases: [/getting-started/results/]
---

After a run, Privateer writes a log file and a results file for each target; the [output schema](/reference/output-schema/#file-locations) has the exact paths. The [configuration reference](/reference/configuration/#top-level-settings) lists every setting that affects output. If no files appear, see [No output files](/how-to/troubleshoot/#no-output-files).

## Controlling the output format

The format of the results file is set in your config:

```yaml
output: json
```

This writes `my-github-repo.json` in place of `my-github-repo.yaml`. The [CLI reference](/reference/cli/#output-formats) lists every format and the file each one writes; `pvtr run -o <format>` overrides the config for one run. SARIF output is compatible with the GitHub Security tab, see [SARIF upload for the GitHub Security tab](/how-to/run-in-github-actions/#sarif-upload-for-the-github-security-tab) for how to upload it.

## Suppressing terminal output

To suppress all non-essential log output to the terminal without changing your log level setting, use the `--silent` flag at runtime:

```bash
pvtr run -c config.yml --silent
```

This is useful in CI environments where you want clean pipeline output but still want full results written to disk.
