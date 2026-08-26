# One-off initialisation of this archive. Kept for reference and for cloning
# into the next stats.swiss archive; not run by CI. See docs/PLAYBOOK.md.

library(devtools)
library(deloRean)
library(opentimeseries)

## Step 1: inspect the source
# Which dataflows exist, and what does this one look like?
devtools::load_all()

cl <- sse_codelists(PASTA_FLOW_ID, lang = "fr")
split(cl$code, cl$dimension)

# A one-year sample is enough to see the shape of the cube.
head(sse_data(PASTA_FLOW_ID, start_period = 2024, end_period = 2024))


## Step 2: metadata
# Draft the structural part from the DSD, then hand-curate data-raw/metadata.yaml
# (dimension names, units, aggregation rules, code renamings, details).
source("inst/build_metadata.R")

validate_metadata("data-raw/metadata.yaml")   # must be TRUE *before* sealing
render_metadata(".")     # data-raw/metadata.yaml -> inst/metadata.json


## Step 3: seal
# Stamps inst/metadata.json with the current checksum so that the first
# scheduled run does not re-fetch data that is already current.
archive_seal(generate_checksum_input())


## Step 4: first load and checks
handle_update()
source("inst/generate_shield.R")

devtools::check()
devtools::build_readme()


## Step 5: publish
# archive_push_remote(repo_path = ".", remote_owner = "<your-github-user>")
#
# Then open a listing request (.github/DATA_LISTING_REQUEST.md has the body) at
# https://github.com/opentsi/data-listing-requests/issues/new and, once
# approved, transfer the repository to the opentsi organisation.


## Not applicable to stats.swiss archives
# deloRean::archive_import_history() imports a vintage backlog. The Swiss Stats
# Explorer serves only the current vintage, so there is no backlog to import:
# this archive's history starts at its first CI commit.
