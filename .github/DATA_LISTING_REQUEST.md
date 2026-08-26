Ready-to-file body for a data listing request at
https://github.com/opentsi/data-listing-requests/issues/new

---

**Repository:** https://github.com/benjamin-arfa/ch.fso.pasta

**Dataset:** `ch.fso.pasta` — Arrivals and overnight stays in holiday homes and
collective accommodation, by month (FSO survey PASTA, statistics on
supplementary accommodation). Monthly, 30 series, from 2017.

**Why it belongs in OpenTSI:** it is the direct counterpart of the already
listed `opentsi/ch.fso.hesta` (hotel accommodation) and completes the Swiss
accommodation picture.

**Source:** the FSO's own dissemination platform, Swiss Stats Explorer
(https://stats.swiss), dataflow `CH1.PASTA:DF_PASTA_552_MONTHLY(1.0.0)` over the
SDMX REST API. This is the first OpenTSI archive sourced directly from
stats.swiss rather than through the KOF Time Series Database, so it needs **no
API key** — the `TSDBAPI` secret is not used and the update workflow runs on a
public endpoint.

**Metadata:** `data-raw/metadata.yaml` validates with
`deloRean::validate_metadata()`; `inst/metadata.json` is rendered from it. Every
dimension and code carries labels in de, fr, it and en, taken from the SDMX
codelists.

**Automation:** `.github/workflows/update_data.yaml` runs `handle_update()` on a
monthly schedule aligned to the FSO release calendar and commits any change.
Update detection uses a checksum over a representative aggregate series, as in
the other FSO archives.

**Known limitation:** stats.swiss serves only the current vintage, so this
archive has no imported vintage backlog — its git history starts at the first
automated commit and accumulates revisions from there. This is inherent to the
source, not to the archive.

**Reusability:** `docs/PLAYBOOK.md` generalises the whole procedure so that any
of the 216 stats.swiss dataflows (listed in
`data-raw/discovery/CANDIDATES.md`) can be turned into an OpenTSI archive by
changing a handful of constants.

**Contact:** benjamin-arfa

I am ready to transfer the repository to the `opentsi` organisation once the
listing is approved.
