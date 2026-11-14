---
title: Troubleshooting
description: Common failures, PATH issues, plugin discovery, missing output, policy errors.
weight: 5
aliases: [/developer-reference/troubleshooting/]
---

## pvtr: command not found

Check whether the binary exists where you installed it:

```bash
Get-Command pvtr
ls $HOME/.privateer/bin/pvtr
ls /usr/local/bin/pvtr
```

If found, the install directory is not on PATH:

```bash
export PATH="$PATH:/usr/local/bin"
source ~/.bashrc
```

## permission denied

```bash
chmod +x /usr/local/bin/pvtr
```

On macOS, approve the binary through Gatekeeper: System Settings → Privacy and Security.

## Plugin not discovered

```bash
pvtr list --installed    # check what Core can see
```

The `plugin` value in config must be the installed coordinate exactly as `pvtr list` shows it, such as `openssf/github-repo` (see [target settings](/reference/configuration/#target-settings)). A plugin binary copied into the binaries path by hand is not discovered; install it with `pvtr install --local <path>`. If using a custom binaries path, pass it consistently:

```bash
pvtr run --binaries-path /opt/pvtr-plugins
```

Or set it in config:

```yaml
binaries-path: /opt/pvtr-plugins
```

## No output files

Verify in config:

```yaml
write: true
write-directory: evaluation_results   # must be a writable path
```

Then increase verbosity to identify the failure:

```bash
pvtr run -c config.yml --loglevel debug
```

## Policy validation error at startup

A missing `policy`, an unknown catalog, or an applicability value that matches nothing each fail differently; the [policy reference](/reference/configuration/#policy) lists the symptom and exit code for each. Check the plugin's documentation for valid catalog IDs and applicability values.

## Plugin crash

A plugin that panics or exits unexpectedly ends with an internal error ([exit code](/reference/cli/#exit-codes) `3`); other targets are unaffected. Core does not retry. Check `<target>.log` for the subprocess output. Run the plugin in debug mode to reproduce the failure outside the gRPC boundary:

```bash
./my-plugin debug --target my-target -c config.yml
```

## version returns "edge"

Built from source without a release tag. Expected behavior for development builds. Use a release binary in production pipelines.
