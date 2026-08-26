#!/bin/sh
# Regenerate data-raw/discovery/CANDIDATES.md from the committed SSE catalogue.
# Run by .github/workflows/discover.yaml; needs only jq.
set -eu
SRC=data-raw/discovery/dataflows.json
OUT=data-raw/discovery/CANDIDATES.md
TOTAL=$(jq '.references | length' "$SRC")

{
  echo "# stats.swiss dataflows"
  echo
  echo "Every dataflow published by the Swiss Stats Explorer, as of the last"
  echo "\`discover\` workflow run: **$TOTAL** dataflows across"
  echo "$(jq -r '[.references[].agencyID] | unique | length' "$SRC") agencies."
  echo
  echo "Each row is a candidate OpenTSI archive: copy this repository, change the"
  echo "constants named in [docs/PLAYBOOK.md](../../docs/PLAYBOOK.md) section 5, and"
  echo "rebuild the metadata. Rows whose id ends in \`_MONTHLY\`, \`_QUARTERLY\` or"
  echo "\`_ANNUAL\` are explicitly periodic and therefore the easiest starting points;"
  echo "for the others, check the \`FREQ\` codelist before committing to one repo."
  echo
  echo "Regenerate with: Actions -> Discover stats.swiss structure -> Run workflow."
  echo
  jq -r '
    [.references[] | {ag: .agencyID, id: .id, v: .version, nm: (.name // "")}]
    | sort_by(.ag, .id)
    | group_by(.ag)[]
    | "## \(.[0].ag)\n",
      "| dataflow | version | title |",
      "|---|---|---|",
      (.[] | "| `\(.id)` | \(.v) | \(.nm | gsub("\\|"; "/") | .[0:120]) |"),
      ""
  ' "$SRC"
} > "$OUT"

echo "Written: $OUT ($(wc -l < "$OUT") lines)"
