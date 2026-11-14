# Design: restructure privateerproj.com around Diátaxis

Status: draft for review. Tracked in Linear as REV-1227 (phases: REV-1228 to REV-1231; backlog: REV-1232). Written 2026-11-09 from a five-agent exchange (lenses: purist,
pragmatist, audience, Hugo implementer, content auditor). Every decision below had at
least 4/5 agreement after the agents read each other's proposals, except D6, noted inline.

The individual proposals and ballots were working material and are not kept; this document
is the complete record.

## 1. Problem

The sidebar groups pages by audience ("Getting started" vs "Developer reference"), not by
what the reader is trying to do. The result:

- "Developer reference" holds three how-to guides, one tutorial-shaped page and three
  reference pages, and its CLI page tells operators the section is not for them.
- There is no true tutorial. The quickstart branches by OS, troubleshoots inline, and the
  learner never opens a result. `first-run.md` duplicates it and fails as written (no
  `policy` block, wrong plugin repo, no token).
- The same facts are restated on several pages and now disagree (section 4).
- `hugo.toml` `[menu]` duplicates every page's `title` and `weight`, so adding a page needs a
  config edit, and the menus already drift from page titles.

## 2. Decisions

| # | Decision | Ruling | Vote |
| --- | --- | --- | --- |
| D1 | Top-level axis | Diátaxis mode first: Tutorials, How-to guides, Reference, Explanation. Audience is never a top-level bucket. | 5/5 |
| D2 | Files and URLs | Move files into `tutorials/`, `how-to/`, `reference/`, `explanation/`. Every moved page carries `aliases:` for its old URL. | 4/5 |
| D3 | Navigation source of truth | The Hugo section tree (`site.Sections`, page `weight`, `cascade` in `_index.md`). Delete the `[menu]` block. | 4/5 |
| D4 | `first-run.md` | Delete in Phase 0. Alias its URL to the quickstart; the alias moves with the quickstart in Phase 2. | 5/5; timing ruled by maintainer 2026-11-09 |
| D5 | `quickstart.md` | Rewrite as a true tutorial: one platform path, learner opens the results file and reads one control, troubleshooting moved out. | 5/5 |
| D6 | `build-a-plugin.md` | Label **How-to guide** now. Move its reference content out (exit codes, result and chain-halting table, scaffold layout). Promote to Tutorial only when a bundled sample catalog ships, so the walk is guaranteed to succeed. | 2 How-to, 2 Tutorial, 1 label-now-split-later. Converged because both Tutorial voters conditioned on the sample catalog, which is out of scope here. |
| D7 | Scope of new pages | Regroup and split existing pages only. Gap pages are a backlog, written one at a time on evidence of demand. Never ship stubs or empty sections. | 5/5 |
| D8 | Phase 0 | Fix factual contradictions in their own PR before any restructure, verified against source and a real `pvtr run`. | 5/5 |
| D9 | `tldr.md` | Explanation. Lives at `content/explanation/tldr.md` with `url: /tldr/` and `type: tldr`, so URL and layout are unchanged. Listed first under Explanation as "Privateer in pictures". | 5/5 |
| D10 | `library.md` | Keep the URL. It becomes the docs landing, rendering the four sections from the same tree as the sidebar. Replace the `"Introduction to Privateer"` string match with `featured: true` front matter on the tutorial. | 5/5 |
| D11 | Header tabs | Home / Docs. Docs points at `/library/`, the docs landing, and is active on every docs page. | 4/5 for one docs tab; target ruled by maintainer 2026-11-09 |
| D12 | Homepage `[[params.fits]]` | Reword cards to what is documented. Drop the GitLab, Jenkins, Terraform and Kubernetes promises until pages exist. Repoint URLs. | 5/5 |

Rulings on items the ballot missed, where the ballots agreed:

- **Prev/next** stays within the current section. No chaining from Glossary into CLI reference.
- **Audience sub-groups inside How-to**: none. Revisit when How-to exceeds about eight pages.
  Until then plugin-author pages sit at the end of the How-to list.
- **`results.md`** splits: "Controlling the output format" and "Suppressing terminal output"
  become the how-to `how-to/control-output.md`; its settings table moves into the
  configuration reference; its "no output files" tail is already in troubleshooting. The
  explanation it promised ("what a result means") is the first backlog item, not written now.
- **Section landing pages**: `_default/section.html` renders `.Content` then a card list of
  `.Pages.ByWeight`, so `/tutorials/` and friends are real pages and valid alias targets.
- **Hard-coded CTA paths** in `index.html`, `tldr/single.html`, `rich-footer.html` and
  `library/single.html` switch to `(site.GetPage "/tutorials/first-run").RelPermalink`, so a
  future move fails the build instead of 404ing.
- **Merged tutorial slug**: `tutorials/first-run/`, title "Your first validation run".
- **Fragment loss**: aliases are meta-refresh pages on GitHub Pages and drop `#anchors`.
  Accepted. Internal links are rewritten; only external deep links are affected.
- **Archetypes per quadrant**: not in scope. Cheap to add later if authors drift.
- **Homepage audience "doors"**: out of scope. The audience agent withdrew them.

## 3. Target tree

```text
content/
├── _index.md
├── library.md                       # unchanged front matter (D10)
├── tutorials/
│   ├── _index.md                    # weight 1, cascade type: docs, aliases: [/getting-started/]
│   └── first-run.md                 # quickstart + first-run merged, rewritten (D4, D5)
├── how-to/
│   ├── _index.md                    # weight 2
│   ├── install.md                   # was getting-started/installation.md
│   ├── upgrade.md                   # was getting-started/upgrading.md
│   ├── control-output.md            # task half of getting-started/results.md
│   ├── run-in-github-actions.md     # was developer-reference/github-actions.md
│   ├── troubleshoot.md              # was developer-reference/troubleshooting.md
│   └── build-a-plugin.md            # was developer-reference/build-a-plugin.md (D6)
├── reference/
│   ├── _index.md                    # weight 3, aliases: [/developer-reference/]
│   ├── cli.md                       # was cli-reference.md; gains exit-code table; loses audience note
│   ├── configuration.md             # gains output-settings table from results.md; loses sed recipe
│   ├── output-schema.md             # rewritten in Phase 0
│   ├── plugin-catalog.md
│   └── glossary.md                  # was getting-started/glossary.md
└── explanation/
    ├── _index.md                    # weight 4
    ├── tldr.md                      # url: /tldr/, type: tldr (D9)
    └── introduction.md              # was getting-started/introduction.md; trim reference tables
```

`content/getting-started/` and `content/developer-reference/` are deleted.

Front-matter rules: `title`, `description` and `weight` required on every page. `type` never
set per page (inherited via `cascade`). `linkTitle` optional for short sidebar labels.
`aliases` required on every moved page.

Alias table (freeze before the move PR):

```text
/getting-started/                     -> /tutorials/
/getting-started/quickstart/          -> /tutorials/first-run/
/getting-started/first-run/           -> /tutorials/first-run/
/getting-started/installation/        -> /how-to/install/
/getting-started/upgrading/           -> /how-to/upgrade/
/getting-started/results/             -> /how-to/control-output/
/getting-started/introduction/        -> /explanation/introduction/
/getting-started/glossary/            -> /reference/glossary/
/developer-reference/                 -> /reference/
/developer-reference/cli-reference/   -> /reference/cli/
/developer-reference/configuration/   -> /reference/configuration/
/developer-reference/output-schema/   -> /reference/output-schema/
/developer-reference/plugin-catalog/  -> /reference/plugin-catalog/
/developer-reference/build-a-plugin/  -> /how-to/build-a-plugin/
/developer-reference/github-actions/  -> /how-to/run-in-github-actions/
/developer-reference/troubleshooting/ -> /how-to/troubleshoot/
```

## 4. Phase 0: factual contradictions

Each fact gets one reference home; every other page links to it. Answers below were read
from source on 2026-11-09 at `privateer` 77a7c30 and `privateer-sdk` fff7364, and updated
2026-11-13 for pvtr v0.24.3 / SDK v1.35.0. Items marked
"confirm with a run" are settled by source but worth one real `pvtr run` before publishing.

| Fact | Docs today | Answer from source | Owner page |
| --- | --- | --- | --- |
| Result values | six Gemara results vs `pass/fail/skip/error` (output-schema, troubleshooting) | Six Gemara results. `pass/fail/skip/error` is stale. Files spell them `Passed`, `Failed`, `Needs Review`, `Not Applicable`, `Not Run`, `Unknown` (run 2026-11-13). (`pluginkit/exitcode.go`, `evaluation_suite.go`) | reference/output-schema |
| Results file path | `<service-name>.yaml` vs `results.yaml` | `<write-directory>/<service>/<service>.<ext>`; write-directory defaults to `evaluation_results`. `gemara` output also writes `.yaml`. (`evaluation_orchestrator.go` `writeResultsToFile`) Confirmed by a run on pvtr v0.24.3, 2026-11-13, for all four formats. | reference/output-schema |
| Output formats | yaml, json, sarif | yaml (default), json, sarif, **gemara** (native EvaluationLog list). (`command/base.go`) | reference/cli |
| Exit codes | "non-zero means failed" vs 0 to 5 table (build-a-plugin only) | build-a-plugin table is correct: 0 pass, 1 fail, 2 aborted, 3 internal error, 4 bad usage, 5 no tests. Code 1 is returned for any suite that is Failed, NeedsReview or Unknown. Multi-plugin runs report the most severe. Since pvtr v0.24.3, a config that requests no plugins (empty or missing file) exits 5, not 0 (privateer-sdk#360, verified 2026-11-13). Run 2026-11-13: a missing required var or missing policy exits 3 (the plugin rejects its config); a catalog the plugin lacks exits 4; an unknown applicability value exits **0** with every requirement `Not Applicable`, so the old "5 = catalog or applicability mismatch" gloss is wrong. (`shared/exitcodes.go`, `command/run.go`) | reference/cli |
| Plugin install identifier | five variants | `pvtr install <namespace>/<plugin_id>[@<version>]` from grc.store. The scanner is `openssf/github-repo` (its publish workflow identity; #26 and #28 already fixed the install commands). `ossf/pvtr-github-repo-scanner` is the GitHub repo, not an install coordinate. Bare names are rejected. Also `--local <path>` (installs as `local/<binary name>`) and `--from-config`. The config `plugin:` value is the same coordinate; a bare binary name is "not installed", and a binary copied into the binaries path by hand is not discovered (run 2026-11-13). (`command/install.go`) | reference/cli |
| Token injection | `{{TOKEN}}` "injected at runtime" via `TOKEN=... pvtr run` (quickstart) vs "no env interpolation, use sed" (configuration) | Both wrong as of pvtr v0.24.3 (SDK v1.35.0, privateer-sdk#344 fixing #343). Nothing substitutes `{{...}}`. Plugin vars are read from env and override the config file, in this order (last wins): config file (global `vars` < target `vars`), `PVTR_VARS_<KEY>`, `PVTR_SERVICES_<TARGET>_VARS_<KEY>` (legacy), `PVTR_TARGETS_<TARGET>_VARS_<KEY>`. Hyphens in keys map to underscores (`api-key` → `API_KEY`). Dots map to underscores too. So a required `token` var can be omitted from the file and set with `PVTR_VARS_TOKEN`. **Run 2026-11-13 corrects the requirement:** the overlay runs inside the plugin process (`config.NewConfig`), so it needs the *plugin* built with privateer-sdk ≥ v1.35.0; pvtr's version does not matter. The published scanner, `openssf/github-repo` v0.33.2, links SDK v1.34.1 and fails with "missing required variables: [token]" (exit 3). Rebuilt against v1.35.0 (ossf/pvtr-github-repo-scanner#536, open) the env token is accepted. (`config/config.go` `overlayEnvVars`) | reference/configuration |
| Policy required | required outside debug (configuration) vs omitted (first-run) | Required whenever a target is named: both `policy.catalogs` and `policy.applicability` must resolve (per-target, falling back to top level) or config is invalid; the plugin rejects it at startup and the run exits 3 (run 2026-11-13). (`config/config.go`) | reference/configuration |
| Config key for targets | all examples use `services:` | `targets:` is current; `services:` is a legacy alias, ignored when `targets:` is present. (`config/config.go` `targetsKey`) | reference/configuration |
| `pvtr list` flags | `-a` vs `--installed` | Both exist: no flag (installed plus requested in config), `-a/--all` (that plus every plugin published on grc.store, despite its help text), `--installed`, `--installable` (published, not installed). Mutually exclusive. (`command/list.go`) | reference/cli |
| Debug / target flag | `--service` vs `--target` | Both work: `--target` is primary, `-s/--service` is an alias. | reference/cli |
| Registry claim | "no authoritative registry, on the roadmap" (plugin-catalog) vs "vetted registry" (cli) | Both stale. `pvtr install` pulls signed OCI artifacts from grc.store. (`command/install.go`) | reference/plugin-catalog |

Undocumented flags found while checking (CLI reference gaps, fix in the same PR):
`--include-payload`, `--concurrency`, `--autoinstall`, `--hub-url`, `install --from-config`,
`install --local`, `list --installable`.

## 5. Template changes

- `hugo.toml`: delete `[menu]`. Update the six `[[params.fits]]` URLs and reword per D12.
- `partials/sidebar.html`: one loop over `(where site.Sections "Type" "docs").ByWeight`, then
  `.Pages.ByWeight`. Keep `.nav-group` markup and `aria-current` so CSS and JS are untouched.
- `partials/header.html`: two tabs, Home and Docs; Docs links to `/library/` and is active when `.Type` is `docs` or the page is the library.
- `docs/single.html`: prev/next from `.CurrentSection.Pages.ByWeight`. Delete the menu
  flattening and the `"Getting started"` title comparison. Breadcrumb from
  `.CurrentSection.Title` already works.
- `_default/section.html`: render content plus child-page cards; drop `activeTab "start"`.
- `library/single.html`: loop over docs sections; `featured: true` replaces the name match.
- `_default/index.json`: no change. `group` picks up the quadrant from `.CurrentSection.Title`.
- `index.html`, `tldr/single.html`, `partials/rich-footer.html`: CTAs via `site.GetPage`.

## 6. Phases

All phases ship in **one PR** from one branch, `docs/diataxis-restructure`, with at least one
commit per phase so each stays reviewable on its own (maintainer ruling 2026-11-13: one review
for all doc and site changes). Each phase must still leave the site building and correct, so
the commits stay in order. Diátaxis: change structure from the inside, no empty shells.

1. **Phase 0, accuracy.** Fix section 4 in place. No moves, no nav change. Acceptance: every
   fact in section 4 appears once as reference and is linked everywhere else; one real run on
   pvtr v0.24.3 confirms the results file path and that `PVTR_VARS_TOKEN` supplies the token. Phase 0 also
   deletes `getting-started/first-run.md`, removes its `[[menu.getting_started]]` entry from
   `hugo.toml`, and adds `aliases: [/getting-started/first-run/]` to the quickstart.
2. **Phase 1, mechanics with zero URL change.** Add `cascade`, `description`, `linkTitle` to
   the two existing `_index.md` files. Switch sidebar, prev/next, library, header and section
   template to the tree. Delete `[menu]`. Acceptance: build before and after and diff
   `public/`; only prev/next at section boundaries may differ.
3. **Phase 2, the move.** `git mv` into the four sections, add every alias (the
   quickstart carries both its own old URL and first-run's), split `results.md`, move the
   `tldr.md` file, update fits and CTAs and the seven internal links. Acceptance: a script asserts every old URL in section 3 exists as
   `public/<old>/index.html`, and `grep -r 'getting-started\|developer-reference' content layouts hugo.toml`
   matches only `aliases:` lines.
4. **Phase 3, content.** Rewrite the merged tutorial (D5). Trim reference tables out of
   `introduction.md` and `build-a-plugin.md` into their reference homes. One commit per page.

### Working notes for implementers

- **Branches and pushing.** One branch, `docs/diataxis-restructure`, for every phase. Commit
  with `-s`. Do not push or open PRs: this repo is outside the agent push exceptions, so the
  maintainer pushes.
- **Build.** `hugo --minify` (local Hugo is v0.160.1 extended; CI deploys from
  `.github/workflows/deploy.yml`). `hugo server` to preview at `http://localhost:1313`.
- **Lint.** CI runs markdownlint on every `*.md`, including this file. Locally:
  `npx --yes markdownlint-cli2 "**/*.md"`. Config is `.markdownlint-cli2.yaml`.
- **Site rules.** Custom layouts and partials, no theme. The site has no `CLAUDE.md`; the
  one deleted in #17 described the old Docsy site and does not apply.
- **Source of truth for facts.** The top-level `../privateer`, `../privateer-sdk` and
  `../pvtr-github-repo-scanner` checkouts, never the copies under `../sandbox/`.
- **Real run for Phase 0.** Use pvtr v0.24.3 or later (the `pvtr` on `PATH` may be older;
  check `pvtr version`). It needs `pvtr install openssf/github-repo` and a GitHub token in
  `PVTR_VARS_TOKEN`.

## 7. Backlog (not in this project, write on demand, never as stubs)

How-to: install a plugin; write a policy block; scan several or private repositories; pass
secrets into config (merge the two duplicate recipes); show results in the GitHub Security
tab (split from GitHub Actions); publish results to grc.store; pin a plugin version; run
offline; GitLab CI or Jenkins (only if the homepage claim is restored).

Explanation: what a result means and why absent data is NeedsReview; the evaluation model;
Privateer and Gemara; why plugins and the trust model; catalog distribution.

Tutorial: build your first plugin with a bundled sample catalog. Needs an owner for the
catalog (plugin-generator-templates or the site). Unblocks promoting `build-a-plugin` (D6).

Reference: plugin SDK page that links pkg.go.dev rather than hand-maintaining the API.

## 8. Maintainer rulings (2026-11-09, revised 2026-11-13)

- **Header tabs**: Home / Docs, with Docs pointing at `/library/`. A third Library tab would duplicate it.
- **Sidebar order**: Tutorials, How-to guides, Reference, Explanation (Diátaxis convention). Set by `weight` on each `_index.md`.
- **D6**: accepted as written. `build-a-plugin` is a How-to guide now; the sample catalog stays in the backlog until an owner is named.
- **Token injection** (revised 2026-11-13): env var only. The quickstart, GitHub Actions page
  and configuration reference pass the token as `PVTR_VARS_TOKEN` and state that pvtr ≥ 0.24.3
  is required. The `sed` recipe is removed everywhere. Supersedes the 2026-11-09 sed ruling.
- **`targets:` key**: Phase 0 switches every config example from `services:` to `targets:`.
  The configuration reference notes that `services:` still works as a legacy alias and is
  ignored when `targets:` is present.

## 9. Rejected alternatives

- Audience-first top level (Run Privateer / Build a plugin, Diátaxis inside each). Fifteen
  pages cannot fill eight boxes; most reference serves both audiences; the Diátaxis page cited
  for it is a 404.
- Keep files where they are and regroup only via menus. Leaves directories and navigation
  disagreeing by design, forcing menu-lookup workarounds in breadcrumb and search forever.
- A `diataxis:` or `group:` front-matter param. The directory already names the quadrant; a
  second copy drifts.
- Planning the full ~30-page target now. A list that long is a plan, not a map; several
  proposed pages would be one paragraph each.
- Fold `tldr.md` into the introduction, or drop the library page.
