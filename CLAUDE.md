# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

**Read [`docs/PLAYBOOK.md`](docs/PLAYBOOK.md) first.** It is the reusable recipe
for stats.swiss-sourced OpenTSI archives and explains why each file exists.

## What this is

An OpenTSI data archive: an R package that (a) carries versioned time series as
CSV files under git, and (b) contains the ETL that refreshes them from the
provider. Vintages are git commits, not files.

Unlike the other FSO archives in the OpenTSI organisation, this one sources data
from the **Swiss Stats Explorer** SDMX API at `disseminate.stats.swiss`, not
from the KOF Time Series Database. There is no API key and no `TSDBAPI` secret.

## Common commands

```r
# Dependencies
pak::pkg_install(c("opentsi/opentimeseries", "opentsi/deloRean"))

devtools::load_all()
devtools::document()   # regenerate NAMESPACE and Rd files
devtools::check()

deloRean::validate_metadata("data-raw/metadata.yaml")
deloRean::render_metadata(".")      # -> inst/metadata.json
```

Nothing here can be run without network access to `disseminate.stats.swiss`. In
a sandbox without that egress, use the `discover` GitHub Actions workflow: it
fetches from the runner and commits the result under `data-raw/discovery/`.

## Architecture

- **`R/sse.R`** — minimal SDMX client (httr2 + xml2) for stats.swiss:
  `sse_catalogue()`, `sse_ref()`, `sse_codelists()`, `sse_data()`.
  Dataset-agnostic; copy verbatim into sibling archives.
- **`R/process_data.R`** — the five `PASTA_*` constants at the top plus the key
  composition are the only dataset-specific logic. Fetches the cube, keeps
  `FREQ == "M"`, writes `data-raw/csv/<key>.csv` and `data-raw/index.md`.
- **`R/handle_update.R`** — `handle_update()` (boilerplate, do not edit) and
  `generate_checksum_input()` (per-dataset: which slice detects a publication).
- **`data-raw/metadata.yaml`** — source of truth. Key pattern
  `ch.fso.pasta.<accommodation>.<indicator>.<origin>.<operation>`.
  `update_checksum` at the bottom is managed programmatically — do not edit it.
- **`inst/metadata.json`** — rendered artifact consumed by `opentimeseries`.
- **`inst/build_metadata.R`** — drafts the structural metadata from the DSD.
- **`inst/check_metadata_labels.R`** — CI consistency assertions.
- **`inst/boilerplate.R`** — the one-off initialisation script, for reference.

### Update flow

```
handle_update()
  └── generate_checksum_input()   # per-dataset: a representative slice
  └── is_update_needed()          # opentimeseries: compares to inst/metadata.json
  └── update_checksum()           # opentimeseries: writes the new checksum
  └── process_data()              # per-dataset: fetch -> csv -> index
```

### CI

- `check.yaml` — on every push: metadata validation, label consistency,
  `source_url` reachability, `R CMD check`.
- `update_data.yaml` — monthly cron plus manual dispatch. The `seal` input runs
  validate + render + `archive_seal()` instead of the update; run it once after
  changing metadata, before the first data run.
- `discover.yaml` — manual. Snapshots the stats.swiss catalogue and a
  dataflow's structure into `data-raw/discovery/`.

## Conventions

- Series keys carry **no** `ch.fso.pasta.` prefix; the repo supplies it.
- CSVs are `time,value`, unquoted, `time` is the first day of the month.
- SDMX `_T` (total) is written `tot` in keys, matching `opentsi/ch.fso.besta`.
- Do not add a vintage backlog: stats.swiss has none. See the README.
