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

## Installation Methods

### Option 1: Install via Script (Recommended)

The easiest way to install Privateer is using the provided installation script:

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/privateerproj/privateer/03ced90caae9f3c9203eb7f82f2c46ccf2ff15fc/install.sh)"
```

This script will:
- Download the latest Privateer release
- Install it to the appropriate location
- Set up the necessary directories
- Add Privateer to your PATH (if configured)

> [!NOTE]
> The installation script uses a specific commit hash. For the latest version, check the [Privateer repository](https://github.com/privateerproj/privateer) for the most recent install script.

### Option 2: Download from Releases

You can manually download and install Privateer from GitHub Releases:

1. **Visit the Releases Page**: Go to [GitHub Releases](https://github.com/privateerproj/privateer/releases)

2. **Download the Binary**: Download the appropriate binary for your operating system and architecture:
   - Linux: `privateer-linux-amd64` or `privateer-linux-arm64`
   - macOS: `privateer-darwin-amd64` or `privateer-darwin-arm64`
   - Windows: `privateer-windows-amd64.exe`

3. **Install the Binary**:
   
   **Linux/macOS:**
   ```bash
   # Rename and move to a directory in your PATH
   mv privateer-* /usr/local/bin/privateer
   chmod +x /usr/local/bin/privateer
   ```
   
   **Windows:**
   - Move the executable to a directory in your PATH, or add the directory to your system PATH

4. **Create Privateer Directories** (if needed):
   ```bash
   mkdir -p $HOME/.privateer/bin
   ```

### Option 3: Build from Source

If you want to build Privateer from source or need a custom build:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/privateerproj/privateer.git
   cd privateer
   ```

2. **Install Dependencies**:
   ```bash
   go mod tidy
   ```

3. **Build Privateer**:
   ```bash
   make release
   ```

   This will create the Privateer binary in the repository directory.

4. **Install the Binary**:
   ```bash
   # Copy to a directory in your PATH
   cp privateer /usr/local/bin/
   # Or on macOS:
   cp privateer-darwin /usr/local/bin/privateer
   ```

## Verify Installation

After installation, verify that Privateer is working correctly:

```bash
privateer version
```

You should see version information displayed, for example:

```
Privateer version 0.0.0
```

If you see an error, check that:
- The Privateer binary is in a directory that's in your PATH
- The binary has execute permissions (on Linux/macOS)
- You're using the correct command name

## Post-Installation Setup

### Create Required Directories

Privateer uses a default directory structure for plugins and configuration:

```bash
mkdir -p $HOME/.privateer/bin
```

This directory is where plugins will be installed by default.

### Configure Your PATH

If Privateer isn't found after installation, you may need to add it to your PATH:

**Linux/macOS:**
Add to your `~/.bashrc`, `~/.zshrc`, or equivalent:

```bash
export PATH="$PATH:/usr/local/bin"
```

**Windows:**
Add the directory containing the Privateer executable to your system PATH through System Properties.

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
   chmod +x /path/to/privateer
   ```

2. **Check Directory Permissions**: Ensure you have write access to `$HOME/.privateer/bin`

### Version Check Fails

If `privateer version` doesn't work:

1. **Verify Binary**: Check that the binary file is not corrupted
2. **Re-download**: Try downloading and installing again
3. **Check Architecture**: Ensure you downloaded the correct binary for your system architecture

## Next Steps

After successfully installing Privateer:

- Learn how to [install plugins](/docs/users/install-plugins/) to extend Privateer's capabilities
- Follow the [Quick Start guide](/docs/users/#quick-start) to run your first validation
- Explore the [command reference](/docs/users/#common-commands) to understand available commands

