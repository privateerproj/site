---
title: "Debug a Plugin"
linkTitle: "Debug a Plugin"
weight: 11
description: >
  Learn how to run a Privateer plugin in debug mode for testing and development.
---

## Running the Generated Plugin

### Running in Debug Mode

To run the plugin by itself in debug mode:

```bash
./example debug --service my-cloud-service1
```

> [!TIP]
> If you use a different service name, make sure the service name matches what is in the config.yml in the root of the repository.

> [!IMPORTANT]
> The `test_output/[service_name]` folder should include a log file and a yaml file for each test suite.
>
> Example: `test_output/my-cloud-service1/my-cloud-service1.log` and `test_output/my-cloud-service1/tlp_red.yml`

### Running from Privateer

To run the plugin from Privateer:

1. **Copy the plugin binary to the Privateer binaries path**:

   ```bash
   cp example $HOME/.privateer/bin
   ```

2. **Copy the configuration to the parent directory**:

   ```bash
   cp config.yml ../
   cd ..
   ```

3. **Run Privateer**:

   ```bash
   privateer run
   ```

