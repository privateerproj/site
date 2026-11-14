---
title: Plugin catalog
type: docs
weight: 6
description: Where to find community plugins for OSPS Baseline, FINOS CCC, and more.
---

Plugins are standalone binaries distributed independently from Core. Published plugins live on [grc.store](https://hub.grc.store), which serves each one as a signed OCI artifact; `pvtr install <namespace>/<plugin_id>` verifies the signature before installing. Run `pvtr list --installable` to see what is published. Install details are in the [CLI reference](/developer-reference/cli-reference/#pvtr-install).

**Finding plugins:**

* GitHub: search repositories prefixed with `pvtr-` or `privateer-`
* OpenSSF: the GitHub repo scanner, `openssf/github-repo` ([source](https://github.com/ossf/pvtr-github-repo-scanner)), for OSPS Baseline validation
* FINOS: plugins for Common Cloud Controls and Compliant Financial Infrastructure validation

## Featured plugins

| Plugin | Target | Catalog |
| --- | --- | --- |
| [pvtr-github-repo-scanner](https://github.com/ossf/pvtr-github-repo-scanner) | GitHub repositories | [OpenSSF OSPS Baseline](https://baseline.openssf.org/) |

Maintain a plugin you'd like listed here? Open a pull request against [this page](https://github.com/privateerproj/site/edit/main/content/developer-reference/plugin-catalog.md).
