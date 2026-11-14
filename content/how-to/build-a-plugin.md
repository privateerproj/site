---
title: Build your first plugin
description: Generate a scaffold, write a loader and typed assessment steps, test in debug mode, and run under pvtr.
weight: 6
aliases: [/developer-reference/build-a-plugin/]
---

A plugin is a Go binary that evaluates one kind of target against a Gemara
Layer 2 control catalog and emits a Gemara EvaluationLog. `pvtr run` launches
it, hands it the config for a target, and collects the log. This page walks
the scaffold as `pvtr generate-plugin` emits it today. The maintained reference
plugin is [pvtr-github-repo-scanner](https://github.com/ossf/pvtr-github-repo-scanner);
when this page and that repo disagree, the repo is current.

## Prerequisites

* Go at the version in the generated `go.mod` (1.26 or later)
* `pvtr` 0.23 or later
* A Gemara Layer 2 control catalog, YAML or JSON, as a file or URL

## Step 1: Generate the scaffold

```bash
pvtr generate-plugin \
  --source-path  ~/path/to/catalog.yaml \
  --service-name MyService \
  --organization my-github-org \
  --output-dir   my-plugin/
```

Then prove it compiles before touching anything:

```bash
cd my-plugin
go mod tidy && go build ./... && go vet ./...
```

A generated plugin ships no `go.sum`, so `go mod tidy` is always the first
command. Do not run `generate-plugin` over an existing plugin; it overwrites
every file.

## Step 2: Review the generated structure

The [CLI reference](/reference/cli/#generated-layout) lists every generated
file. Every requirement id in the catalog is already in `Suite_<id>`, bound to
`reusable_steps.NotImplemented`. Replacing those bindings is the work.

The scaffold vendors the catalog with `AddReferenceCatalogs`, so the binary is
self-contained. If the catalog is published on grc.store, you can declare it by
coordinate with `AddCatalogs("<namespace>/<id>@<version>")` instead and drop the
YAML from `data/catalogs/`. `pvtr install` then fetches, verifies, and caches the
catalog next to the plugin binary, and `pvtr run` reads it from that cache, so
the plugin never contacts grc.store after install. Both options remain
supported; vendoring is fine for catalogs that are not on grc.store or that you
want pinned in the binary.

## Step 3: Write the loader

All I/O happens once, in the loader, before any step runs. The loader returns
the payload; the SDK passes that payload to every step.

```go
// data/data_collection.go
type Payload struct {
    Config   *config.Config
    Owner    string          // resolved from config here, not in steps
    Repo     *RepoData       // pointer: the payload is passed by value
    RepoErr  error           // "could not observe" is distinct from "observed none"
}

func Loader(cfg *config.Config) (any, error) {
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    p := Payload{Config: cfg, Owner: cfg.GetString("owner")}
    repo, err := fetchRepo(ctx, p.Owner)
    if err != nil {
        return nil, fmt.Errorf("github.rest: %w", err)
    }
    if repo.DefaultBranch == "" {
        return nil, fmt.Errorf("github.rest: missing default_branch")
    }
    p.Repo = repo
    return p, nil
}
```

Rules that keep steps honest:

* Bound every call with a context timeout.
* Validate required fields before returning. A half-built payload turns loader
  bugs into false failures.
* Name the source in errors so the run log says which system broke.
* List config vars the loader cannot run without in `RequiredVars` in
  `main.go`. The SDK refuses to run when one is missing.

## Step 4: Write assessment steps

A step is a pure function of the payload. It observes; it never fetches.

```go
// evaluation_plans/evaluation_plans.go (generated)
type TypedStep func(data.Payload) (gemara.Result, string, gemara.ConfidenceLevel)

// evaluation_plans/access_control/steps.go (yours)
func BranchProtectionRequiresReview(p data.Payload) (gemara.Result, string, gemara.ConfidenceLevel) {
    if p.RepoErr != nil {
        return gemara.NeedsReview, "Could not read branch protection: " + p.RepoErr.Error(), gemara.Undetermined
    }
    n := p.Repo.BranchProtection.RequiredReviews
    if n > 0 {
        return gemara.Passed, fmt.Sprintf("Branch protection requires %d review(s)", n), gemara.High
    }
    return gemara.Failed, fmt.Sprintf("Branch protection not enforced: required reviews = %d", n), gemara.High
}
```

Then bind it:

```go
Suite_my_catalog = map[string][]TypedStep{
    "MC.C01.TR01": {
        reusable_steps.RepoWasFetched,           // a scope guard you write; runs first
        access_control.BranchProtectionRequiresReview,
    },
}
```

The [result values](/reference/output-schema/#result-values) table lists the
six results a step can return and which ones halt the chain. Because a chain
stops at the first `Failed` or `NotApplicable`, put scope guards first so an
inapplicable target stops before a substantive step fails it for the wrong
reason.

Three things to get right in every step:

1. **Absent data is never `Failed`.** "No SECURITY.md" is a failure only if the
   loader positively listed the tree. "Could not list the tree" is
   `NeedsReview` with the reason.
2. **The message is evidence, not a label.** Include the value you observed.
3. **Never `Passed` without a positive observation.** Silent green is the worst
   outcome for an evaluator.

`main.go` registers the map with `pluginkit.AddEvaluationSuiteTyped`. The SDK
asserts the payload type once and keeps each step's function name in the
results, so do not wrap steps in closures and do not add a type assertion to
each step.

## Step 5: Test the steps

Table-driven, with the payload built as a literal. No network in `go test`.

```go
func TestBranchProtectionRequiresReview(t *testing.T) {
    tests := []struct {
        name    string
        payload data.Payload
        want    gemara.Result
    }{
        {"enforced", data.Payload{Repo: &data.RepoData{BranchProtection: bp(2)}}, gemara.Passed},
        {"not enforced", data.Payload{Repo: &data.RepoData{BranchProtection: bp(0)}}, gemara.Failed},
        {"unreadable", data.Payload{RepoErr: errors.New("403")}, gemara.NeedsReview},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, _, _ := BranchProtectionRequiresReview(tt.payload)
            if got != tt.want {
                t.Errorf("got %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Step 6: Run in debug mode

Run the binary directly to exercise the loader against a real target without
`pvtr`:

```bash
cp example-config.yml config.yml     # fill in vars for a real target
go build -o my-plugin .
./my-plugin debug --target my-target -c config.yml -l debug
```

Results land in `evaluation_results/my-target/my-target.yaml`. Check that every
requirement shows `steps-executed` of at least 1 and a result other than
`Unknown`. A requirement with no chain in the map is reported as `Unknown`
with a message naming the id.

## Step 7: Run under pvtr

```bash
pvtr install --local ./my-plugin     # installs as local/my-plugin
pvtr list --installed                # confirm it is discovered
pvtr run -c config.yml
```

Under `pvtr`, the target's `plugin` value is the installed coordinate,
`local/my-plugin`. A binary copied into the binaries path by hand is not
discovered.

`pvtr run` exits `1` when the run completed and some assessments failed; that
is a successful run from the plugin's point of view. Every code is listed in the
[CLI reference](/reference/cli/#exit-codes).

## Step 8: Publish to grc.store

Users install plugins from [grc.store](https://hub.grc.store) with
`pvtr install <namespace>/<plugin_id>`. To publish there:

1. Set `Publisher` and `License` on the orchestrator in `main.go`. `Publisher`
   is your grc.store namespace, and with the plugin name it forms the coordinate
   `<publisher>/<plugin-name>`; `License` is an SPDX expression such as
   `Apache-2.0`. Both are required to publish and inert at run time.
2. Create or claim that namespace on grc.store. Publishing to a namespace you
   do not own is refused.
3. Push the plugin to GitHub and tag a release.
4. Run the scaffold's `.github/workflows/publish-plugin.yaml` from the Actions
   tab, giving it the tag. It builds the tag with GoReleaser and runs
   `pvtr publish`, which reads the coordinate, license and catalogs from the
   built binary, pushes the plugin as a signed OCI artifact, and asks the hub to
   verify it. Before the first run, have the hub list your repository as a
   trusted publisher for your namespace.

   To publish from your own machine instead, build and publish directly.
   Signing opens a second browser sign-in, separate from `pvtr login`:

   ```bash
   goreleaser build --clean
   pvtr login
   pvtr publish
   ```

   The first successful publish pins the signer identity for the coordinate,
   so choose one path and keep publishing from it.
5. Document required vars and an example `config.yml` in the README.

The [CLI reference](/reference/cli/#pvtr-publish) lists the `login` and
`publish` flags.

## Using an AI agent

The [privateer-skills](https://github.com/privateerproj/privateer-skills)
repository packages this workflow as an Agent Skill, with a static check that
every catalog requirement has a step chain and a parser for the run output.
