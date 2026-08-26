# Playbook: turning a stats.swiss dataflow into an OpenTSI archive

This document is the reusable recipe for building a
[OpenTSI](https://github.com/opentsi) data archive whose data comes **directly from
[stats.swiss](https://stats.swiss/)** (*Swiss Stats Explorer*, the FSO's .Stat Suite / SDMX
dissemination platform) instead of from the KOF Time Series Database.

It is written to be **copied verbatim into every new `ch.fso.<dataset>` repository**.
This repository (`ch.fso.pasta`, the parahotellerie statistics) is the pilot and is used
throughout as the worked example beside each placeholder.

| Placeholder | Meaning | Value in this pilot |
|---|---|---|
| `<DATASET>` | short dataset id; last segment of the key prefix | `pasta` |
| `<ARCHIVE>` | repo name = R package name = `ch.fso.<DATASET>` | `ch.fso.pasta` |
| `<AGENCY>` | SDMX agency id on stats.swiss | `CH1.PASTA` |
| `<FLOW_ID>` | SDMX dataflow id | `DF_PASTA_552_MONTHLY` |
| `<VERSION>` | dataflow version | `1.0.0` |
| `<FREQ>` | OpenTSI frequency letter (`D W M Q Y I`) | `M` |
| `<DIMS>` | dimensions forming the key, in order | `ACCOMMODATION_TYPE`, `COUNTRY_ORIGIN`, indicator |

---

## 0. Why stats.swiss

The existing FSO archives (`ch.fso.besta`, `ch.fso.hesta`, `ch.fso.ipi`, …) read from the KOF
Time Series Database via `tsdbapi` and therefore need a `TSDBAPI` secret in CI. Sourcing from
stats.swiss instead:

- removes the API-key requirement (SSE is public and unauthenticated),
- removes the dependency on a dataset having been ingested into KOF first, which means
  **every** stats.swiss dataflow becomes a candidate archive,
- puts `source_url` on the actual FSO cube rather than the generic FSO homepage.

The cost: **stats.swiss serves only the current vintage**. There is no vintage backlog to
import, so a stats.swiss archive starts at t₀ and accumulates revisions going forward. See
*Known gaps* below.

---

## 1. Prerequisites

- A repository named exactly `<ARCHIVE>` — i.e. `ch.fso.<DATASET>`. The repo name, the R
  package name in `DESCRIPTION`, and `country.provider.dataset` in `data-raw/metadata.yaml`
  **must all agree**; `opentimeseries::read_open_ts()` and `pak::pkg_install()` both resolve
  through it.
- Settings → Actions → General → Workflow permissions: **Read and write**, so the update
  workflow can commit data back.
- No repository secret is needed. If you are porting a KOF-sourced archive, delete the
  `TSDBAPI` secret and the `tsdbapi` dependency.

---

## 2. Pick the dataflow

The stats.swiss catalogue lives at:

```
https://disseminate.stats.swiss/rest/dataflow
```

Dispatch the `discover` workflow with no `flow_id` (see §3) to snapshot it into
`data-raw/discovery/dataflows.json`, then choose a flow. Rules:

1. **One repo = one dataflow = one frequency.** OpenTSI requires every series in a dataset to
   share a frequency. If a flow mixes `M` and `A` in its `FREQ` codelist, either filter to a
   single frequency in the query or split it into two repos (`…_MONTHLY` / `…_ANNUAL` flows on
   stats.swiss are usually already split for you).
2. **Prefer flows that are siblings of an existing OpenTSI archive** — the key structure,
   `dim_order` and `hierarchy` can then be mirrored from that archive instead of designed from
   scratch. The pilot mirrors [`opentsi/ch.fso.hesta`](https://github.com/opentsi/ch.fso.hesta).
3. Note the agency (`<AGENCY>`, e.g. `CH1.PASTA`) and version (`<VERSION>`) — the data URL
   needs all three parts.

`data-raw/discovery/CANDIDATES.md` in this repo holds the shortlist of flows worth doing next.

---

## 3. Run discovery

`.github/workflows/discover.yaml` is dataflow-agnostic. Dispatch it (Actions → Discover
stats.swiss structure → Run workflow) with:

| input | effect |
|---|---|
| `flow_id` empty | dumps the whole catalogue → `data-raw/discovery/dataflows.json` |
| `flow_id = <FLOW_ID>` | additionally dumps the DSD + codelists in `de`, `fr`, `it`, `en` → `data-raw/discovery/<FLOW_ID>.<lang>.xml` |

It commits the results back to the branch. This exists because a sandboxed development
container generally cannot reach `*.stats.swiss` — the runner can, so the runner does the
fetching and the repo carries the answer.

The endpoints it calls:

```
# catalogue
GET https://disseminate.stats.swiss/rest/dataflow

# structure (DSD + codelists + the CubeRegion of codes actually present)
GET https://disseminate.stats.swiss/rest/dataflow/<AGENCY>/<FLOW_ID>/<VERSION>?references=all

# data (SDMX generic XML)
GET https://disseminate.stats.swiss/rest/data/<AGENCY>,<FLOW_ID>,<VERSION>/<key>?startPeriod=YYYY&dimensionAtObservation=AllDimensions
```

`<key>` is the dimension values in DSD position order, joined by `.`, with `+` for multiple
values and an empty segment for "all" — e.g. `M.552001.CH+AUSL.` — or the literal `all`.

---

## 4. Generate and curate the metadata

Run `inst/build_metadata.R` (it runs in CI as part of discovery, or locally if you have R and
network access). It reads the discovery XML and emits a first-draft `data-raw/metadata.yaml`.
**Always hand-check the draft** — the codelists are machine-generated and the hierarchy usually
needs judgement.

Mapping rules from SDMX to the OpenTSI schema:

| SDMX | OpenTSI `metadata.yaml` |
|---|---|
| `Dataflow/Name[@xml:lang]` | `title.{en,de,fr,it}` |
| `DimensionList/Dimension@id` (minus `FREQ`, `TIME_PERIOD`) | `dim_order`, in `@position` order |
| `Codelist/Code@id` | the values inside `hierarchy` |
| `Codelist/Code/common:Name[@xml:lang]` | `labels.dimnames.<code>.{en,de,fr,it}` |
| `Codelist/Code/@parent` | the nesting inside `hierarchy` |
| `CubeRegion/KeyValue/Value` | which codes are *actually present* — restrict to these, a codelist is usually larger than the cube |
| `FREQ` code | `dataset_frequency` (`<FREQ>`) |

Required fields (schema: `deloRean::view_schema()`, published at
<https://opentsi.github.io/schema/v1/metadata.json>): `country`, `provider`, `dataset`,
`title`, `source_name`, `source_url`, `dataset_frequency`. English is mandatory in every
multilingual block; stats.swiss gives you all four Swiss languages, so fill all four.

Set `source_url` to the cube's page on stats.swiss, not to `https://www.fso.admin.ch`.

Then:

```r
deloRean::validate_metadata("data-raw/metadata.yaml")   # must return TRUE
deloRean::render_metadata()        # data-raw/metadata.yaml -> inst/metadata.json
```

> **Schema caveat.** The published JSON schema pins `update_checksum` to `^[a-f0-9]{32}$`
> (MD5), while `deloRean::archive_seal()` and `opentimeseries::is_update_needed()` both write
> and compare SHA-256 (64 hex chars). `deloRean::validate_metadata()` does not check that
> field, so the R-side validation passes either way — but validating a *sealed*
> `inst/metadata.json` against the published schema fails on a value the tooling itself wrote.
> Keep the order validate → render → seal, and do not hand-edit `update_checksum`.

---

## 5. Wire the ETL

Three files. Only the marked parts change per dataset.

### `R/sse.R` — **does not change**

A minimal SDMX client over `httr2` + `xml2`, modelled on `BFS::bfs_get_sse_*()` (CRAN pkg
`BFS` ≥ 0.7.0) but without its heavy dependency chain (`pxweb`, `rvest`, `janitor`, `dplyr`,
`tidyr`, `purrr`), which is slow and brittle to build on the Alpine CI image.

- `sse_url(flow_id, metadata = FALSE)` — resolve `<AGENCY>,<FLOW_ID>,<VERSION>` from the catalogue
- `sse_codelists(flow_id, lang)` — DSD + codelists + CubeRegion → data.frame
- `sse_data(flow_id, query, start_period)` — SDMX generic XML → long data.frame

Copy it as-is into a new archive.

### `R/process_data.R` — **change 3 things**

1. the `<FLOW_ID>` constant,
2. how the key is composed from the dimension columns (`<DIMS>`, joined by `.`),
3. nothing else — the CSV writing and `data-raw/index.md` regeneration are generic.

Output contract, identical to every other OpenTSI archive:

```
data-raw/csv/<key>.csv     # cols: time,value  — time is YYYY-MM-01, no quoting
data-raw/index.md          # "- [<key>](csv/<key>.csv)" per series
```

The key carries **no** `ch.fso.<DATASET>.` prefix — the prefix is implied by the repo.

### `R/handle_update.R` — **change 1 thing**

`generate_checksum_input()` must return something that changes exactly when the FSO publishes.
Fetch **one representative aggregate series** (the national total, all categories) via
`sse_data()` and return it; `opentimeseries::is_update_needed()` hashes it. Change only which
series that is. Because SSE needs no key, `handle_update()` takes no arguments — drop the
`key =` parameter the KOF-sourced archives carry.

The orchestration itself is boilerplate and should not be edited:

```
handle_update()
  └── generate_checksum_input()   # per-dataset
  └── is_update_needed()          # opentimeseries
  └── update_checksum()           # opentimeseries
  └── process_data()              # per-dataset
```

---

## 6. Schedule

`.github/workflows/update_data.yaml` runs `handle_update()` on cron and commits any change.
Pick the cron from the FSO release calendar for your statistic, not from a generic default:
run a few days on either side of the expected publication so a slipped release is still caught,
and rely on the checksum to make the extra runs no-ops.

Pilot: parahotellerie publishes roughly five weeks after the reference month, so
`cron: "0 6 8,12,16 * *"`.

Also set `permissions: contents: write` so the bot can push the data commit.

**Runner note.** The KOF-sourced archives run R inside `devxygmbh/r-alpine` and install with
`pak`. This archive uses `ubuntu-latest` with `r-lib/actions/setup-r` and
`setup-r-dependencies`, which pulls binaries from the public RSPM instead of compiling on
Alpine — noticeably faster and far less likely to fail on a system-library mismatch. The
workflow is otherwise the same shape, and `handle_update()` does not care which runner it is
on.

Two more details worth copying:

- Install the package from the checkout (`local::.`), not from GitHub. Installing from the
  repository would fetch the *default* branch, which is not what you are testing on a feature
  branch.
- Give the workflow a `seal` boolean input. `opentimeseries::update_checksum()` refuses to run
  while `update_checksum` is empty, so the archive has to be sealed once before the first data
  run; a dispatch input beats a one-off local script that nobody can re-run later.
- **Load the data inside the seal step, before stamping the checksum.** Sealing asserts "the
  archive reflects this state". The KOF-sourced archives seal after importing a vintage
  backlog, so their data is already on disk; a stats.swiss archive has no backlog, so sealing
  an empty archive would make the first scheduled run correctly report "no update needed"
  against an empty `data-raw/csv`. Order: render → `process_data()` → `archive_seal()`.

---

## 7. Seal, verify, list, transfer

Follow `vignette("general_workflow", package = "deloRean")`. Condensed:

```r
# once, after metadata is valid and rendered
deloRean::archive_seal(generate_checksum_input())
```

Acceptance checklist before requesting a listing:

- [ ] `deloRean::validate_metadata("data-raw/metadata.yaml")` returns `TRUE` (run before sealing)
- [ ] `inst/metadata.json` exists and is rendered from `data-raw/metadata.yaml`
- [ ] `devtools::check()` passes — the update workflow installs the package from GitHub, so it
      must actually install
- [ ] a manual `update_data` dispatch commits `data-raw/csv/*.csv`
- [ ] a second dispatch with no new FSO publication prints "No update needed" and commits nothing
- [ ] the archive's data is on a branch named **`main` or `master`** —
      `opentimeseries::get_commit_dates()` hardcodes those two names and ignores the
      repository's configured default branch, so an archive published on any other branch is
      invisible to the client even when that branch *is* the default
- [ ] `opentimeseries::read_open_ts(series = "<a total key>", remote_archive = "<owner>/<ARCHIVE>")`
      returns the series
- [ ] two or three values spot-checked against the figures shown on stats.swiss for the same cube

Then:

1. Open a listing request at
   [`opentsi/data-listing-requests`](https://github.com/opentsi/data-listing-requests/issues/new)
   — repo link, description, confirmation that metadata validates, contact.
   A pre-filled body is kept at `.github/DATA_LISTING_REQUEST.md`.
2. Once approved, Settings → Danger Zone → **Transfer repository** to `opentsi`. An admin
   accepts and grants you maintainer access; the old URL keeps redirecting.

---

## 8. Known gaps

- **No vintage backlog.** stats.swiss exposes only the current vintage, so
  `deloRean::archive_import_history()` has no input and is skipped. The git history starts at
  the first CI commit. Say so in the README so consumers do not read the first commit as a
  1990s vintage. (KOF-sourced archives such as `ch.fso.besta` *do* have a backlog, via
  `tsdbapi::read_ts_history()`.)
- **`update_checksum` schema mismatch** — see the note in §4.
- **`opentimeseries::update_checksum()` stores its argument verbatim.**
  `is_update_needed()` compares the stored value against `digest(input, "sha256")`, so
  handing `update_checksum()` the raw series — which is what the boilerplate and the
  KOF-sourced archives do — writes the whole series into `inst/metadata.json` and makes
  every later run report an update. (Both `opentsi/ch.fso.besta` and `opentsi/ch.fso.hesta`
  currently carry a full series in that field.) The archive is not *wrong* — unchanged data
  produces an unchanged CSV and no commit — but it re-fetches every time and the sealed hash
  is lost after the first update. `R/handle_update.R` here hashes before storing, and
  `inst/check_metadata_labels.R` asserts the field stays a 64-character hash. Worth fixing
  upstream in `opentimeseries` rather than in each archive.
- **Git history is the vintage archive — treat it as append-only.** Every commit that touches
  `data-raw/csv` is a data release, so a squash or a force-push destroys vintages, which is the
  one thing the archive exists to provide. The single exception is the initial publication: up
  to the first `update data` commit there is only one data state, so the setup history can be
  collapsed into one commit. After that, never rewrite.
- **The client only reads `main` or `master`.** See the acceptance checklist in §7. Name the
  branch accordingly before requesting a listing; a repository whose default branch is called
  anything else will pass every other check and still be unreadable.
- **Large cubes.** `dimensionAtObservation=AllDimensions` over a full cube can be tens of MB of
  XML. Chunk the request by one dimension (e.g. per canton) if a single call times out; the
  pilot's `process_data()` shows the pattern.
