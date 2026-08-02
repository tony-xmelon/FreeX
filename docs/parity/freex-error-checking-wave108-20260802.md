# FreeX Error Checking Parity Wave 108

Date: 2026-08-02
Base after sync: `e5ec6fcf9e`

## Diagnosis

The highest FreeX visual triage row (`dialog.ErrorChecking`, previously
`0.103141`) was comparing different semantic states. The committed WPF PNG
came from the older formula-diagnostics tour and showed one `D2` issue. The
current WPF and Avalonia parity routes both consume
`ErrorCheckingDialogPlanner.CreateParityIssues`, which intentionally returns
two rows: `D6` (`#DIV/0!`) and `D7` (formula stored as text).

## Changes

- Refreshed the authoritative WPF PNG from the focused
  `FreeX.App.Host --parity-capture-target dialog.ErrorChecking` route.
- Updated WPF manifest provenance to identify the shared fixture and reject the
  stale one-row tour evidence as a source for this pair.
- Added a cross-host source guard proving both capture routes use the shared
  fixture and do not reintroduce the old inline fixture helper.
- Regenerated the checked-in visual evidence summary.

The refreshed WPF image is the same two-row semantic state as the committed
Avalonia image. WPF PNG SHA-256:
`1BD6056634CDB6AA402A6A212743447185F6536651BEDBCB6283B69A0036B1ED`.

## Evidence

After replacing the stale one-row WPF image, the honest paired triage score is
`0.104142` (sample `0.033760`, luma `0.008819`, non-background `0.061283`).
The previous `0.103141` score must not be treated as an improvement baseline:
it was computed from semantically mismatched PNGs. Both manifests now report
`720x420` logical dimensions, nonblank captures, and the same two-row issue
state.

The Avalonia PNG remains the earlier committed Linux capture asset. A fresh
Linux production recapture is intentionally deferred to the parent agent,
which owns Docker serialization; current source already contains the
Avalonia-specific `704x383` client geometry intended to match WPF's native
frame reserve.

## Verification

- Focused WPF Release host executable targeted capture: produced a nonblank
  `720x420` PNG with `D6` and `D7` rows.
- `Generate-DialogVisualEvidenceSummary.ps1`: 94/94 paired surfaces, 0
  missing IDs, 0 blank PNGs, 0 logical dimension mismatches.
- `FreeX.App.Services.Tests` planner filter: 3/3 passed.
- `FreeX.App.Host.Tests` Error Checking source/fixture filter: 18/18 passed.
- `FreeX.App.Avalonia.Tests` compact dialog source filter: 16/16 passed.

## Residuals

Native WPF versus Avalonia text rasterization, button templates, selected-row
colors, and scrollbar glyphs remain visual differences. The next visual
judgment should use a fresh Linux capture from the current source, not the
older Avalonia PNG, after the semantic fixture correction is integrated.
