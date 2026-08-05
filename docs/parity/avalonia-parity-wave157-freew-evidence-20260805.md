# FreeW Wave157 Canonical Evidence Audit

Date: 2026-08-05

## Canonical aggregate

The tracked canonical comparison is:

`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`

Its current row-derived totals are **158 genuine visual mismatches**, **25 passes**, **105
Avalonia extensions**, and **7 state-not-applicable rows** (295 rows total). The Markdown and
HTML comparison files are generated from that JSON input. The cross-app dashboard consumes the
same JSON and therefore reports 158 mismatches and 25 passes.

`freew_dialog_visual_comparison.json` now declares `scope.kind` as `canonical-inputs-only`: it
covers only the inventory and the two capture manifests passed to the canonical compare run.
The comparison tool's `--check` mode and `tools/Test-FreeWDialogVisualEvidence.ps1` recompute the
row classifications and reject count drift in the JSON, README, or cross-app dashboard.

## Evidence outside the aggregate

The following evidence is real and retained in the wave notes, but was not fabricated into or
silently substituted for the canonical aggregate. It remains **outside the canonical aggregate**:

- **Wave 154:** fresh route-local WPF/Avalonia evidence for `table-properties`, `options`,
  `page-setup`, and `legal-notices` (25 states per host). The integration note and four family
  notes record the captures and measurements. Those temporary capture manifests were not merged
  into the tracked all-dialog comparison.
- **Wave 155:** fresh seven-state `table-properties` evidence, including the improved Cell tab.
  It is a route-local refresh of the same family, not seven additional canonical scenarios. The
  Thesaurus slice is functional source/test evidence and has no new visual comparison rows.
- **Wave 156:** there is **no FreeW dialog route capture**. Wave156 evidence belongs to FreeX
  legacy keytips and FreeP inline table editing, so it is intentionally outside this FreeW
  dialog aggregate.

These boundaries explain why a fresh route note can report improved measurements while the
canonical 158/25 totals remain unchanged. To incorporate a route, run the harness comparison with
the tracked baseline and the route's fresh WPF/Avalonia manifests using `--baseline` and
`--refresh-route`, then regenerate the cross-app dashboard and rerun the generated-doc checks.
