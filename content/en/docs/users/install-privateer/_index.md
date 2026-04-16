---
title: "Install Privateer"
linkTitle: "Install Privateer"
weight: 1
description: >
  Learn how to install the Privateer CLI on your system.
---

## Overview

Privateer can be installed in several ways depending on your needs and preferences. Choose the installation method that best fits your environment.

## Prerequisites

Before installing Privateer, ensure you have:

- A compatible operating system (Linux, macOS, or Windows)
- Appropriate permissions to install binaries and create directories
- Network access to download the installation files

## Installation

### macOS

**Homebrew (Recommended)**

```bash
brew install privateerproj/tap/pvtr
```

This installs the latest release and makes the `pvtr` command available immediately.

**Install Script**

Alternatively, you can use the install script:

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/privateer/main/install.sh)"
```

The script automatically downloads the latest release, verifies the checksum, installs the binary to `~/.privateer/bin`, and adds it to your PATH.

### Linux

**Install Script (Recommended)**

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/privateer/main/install.sh)"
```

The script automatically detects your architecture (x86_64 or arm64), downloads the latest release, verifies the checksum, installs the binary to `~/.privateer/bin`, and adds it to your PATH.

**Manual Download**

Download the archive for your architecture from [GitHub Releases](https://github.com/privateerproj/privateer/releases):

- x86_64: `privateer_Linux_x86_64.tar.gz`
- arm64: `privateer_Linux_arm64.tar.gz`

Then extract and install:

```bash
tar xzf privateer_Linux_*.tar.gz
mv pvtr /usr/local/bin/pvtr
chmod +x /usr/local/bin/pvtr
mkdir -p $HOME/.privateer/bin
```

### Windows

**Install Script (Recommended)**

Using Git Bash, MSYS2, or Cygwin:

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/privateer/main/install.sh)"
```

The script automatically downloads the latest release, verifies the checksum, and installs the binary.

**Manual Download**

Download `privateer_Windows_x86_64.zip` from [GitHub Releases](https://github.com/privateerproj/privateer/releases), extract it, and move `pvtr.exe` to a directory in your system PATH.

### Build from Source

For any platform, if you need the latest development version:

```bash
git clone https://github.com/privateerproj/privateer.git
cd privateer
make build
```

`make build` runs tests and produces the `pvtr` binary. Requires Go 1.26 or later. Copy the binary to a directory in your PATH (e.g. `/usr/local/bin/pvtr` on macOS/Linux).

## Verify Installation

After installation, verify that Privateer is working correctly:

```bash
pvtr version
```

You should see version information displayed, for example:

```
0.0.0
```

If you see an error, check that:
- The Privateer binary is in a directory that's in your PATH
- The binary has execute permissions (on Linux/macOS)
- You're using the correct command name

## Post-Installation Setup

The install script handles directory creation and PATH setup automatically. If you installed manually, ensure:

1. The plugin directory exists: `mkdir -p $HOME/.privateer/bin`
2. The `pvtr` binary is in your PATH

## Troubleshooting

### Command Not Found

If you get a "command not found" error:

1. **Check Installation Location**: Verify where Privateer was installed
2. **Check PATH**: Ensure the installation directory is in your PATH
3. **Use Full Path**: Try running Privateer with its full path to verify it works

### Permission Denied

If you get a permission error:

1. **Check File Permissions**: Ensure the binary has execute permissions:
   ```bash
   chmod +x /path/to/pvtr
   ```

2. **Check Directory Permissions**: Ensure you have write access to `$HOME/.privateer/bin`

### Version Check Fails

If `pvtr version` doesn't work:

1. **Verify Binary**: Check that the binary file is not corrupted
2. **Re-download**: Try downloading and installing again
3. **Check Architecture**: Ensure you downloaded the correct binary for your system architecture

## Next Steps

After successfully installing Privateer:

- Learn how to [install plugins](/docs/users/install-plugins/) to extend Privateer's capabilities
- Follow the [Quick Start guide](/docs/users/#quick-start) to run your first validation
- Explore the [command reference](/docs/users/#common-commands) to understand available commands

