---
title: Understanding results
description: Where output files land, how to control the format, and how to suppress terminal output.
weight: 3
aliases: [/getting-started/results/]
---

After a run, Privateer writes a log file and a results file for each target. With the default settings they land in `evaluation_results/<target>/`; the [output schema](/reference/output-schema/#file-locations) has the exact paths.

```text
evaluation_results/
  my-github-repo/
    my-github-repo.log     # Full execution log for this target
    my-github-repo.yaml    # Structured validation results
```

Two files are written for every target, both named after the target. The `.log` file captures everything Privateer and the plugin did during the run, it is recommended to check this file first when something goes wrong. The results file contains the control-by-control outcome of the validation. Its extension follows the output format.

## Controlling the output format

The format of the results file is set in your config:

```yaml
output: json
```

This writes `my-github-repo.json` in place of `my-github-repo.yaml`. The [CLI reference](/reference/cli/#output-formats) lists every format and the file each one writes; `pvtr run -o <format>` overrides the config for one run. SARIF output is compatible with the GitHub Security tab, see [SARIF upload for the GitHub Security tab](/how-to/run-in-github-actions/#sarif-upload-for-the-github-security-tab) for how to upload it.

Config settings that affect output:

| Setting | Default | Description |
| --- | --- | --- |
| `write-directory` | `evaluation_results` | Where result files are written |
| `write` | `true` | Whether to write output files at all |
| `output` | `yaml` | Results format; see [output formats](/reference/cli/#output-formats) |
| `loglevel` | `error` | Log verbosity: `trace`, `debug`, `info`, `warn`, `error`, `off` |

## Suppressing terminal output

To suppress all non-essential log output to the terminal without changing your log level setting, use the `--silent` flag at runtime:

```bash
pvtr run -c config.yml --silent
```

This is useful in CI environments where you want clean pipeline output but still want full results written to disk.

If no output files appear after a run, check the following:

```yaml
# Confirm these are set in your config
write: true                          # Must not be set to false
write-directory: evaluation_results  # Must be a path you have write access to
```

Then re-run with debug logging to see what went wrong:

```bash
pvtr run -c config.yml --loglevel debug
```
