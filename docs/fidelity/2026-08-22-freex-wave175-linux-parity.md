# FreeX Wave175 Linux Parity

**Date:** 2026-08-22
**Scope:** FreeX Avalonia physical X11 validation at `1280x820`, 96 DPI

## Outcome

The authoritative Docker/X11 selectors are green after one production persistence fix and
three probe-only hardening fixes:

| Selector | Result | Evidence |
| --- | ---: | --- |
| `outline-nested-filter-save-reopen` | 1/1 | `artifacts/linux-interactive/freex/interaction-validation/20260822T060916Z/interaction-validation.json` |
| `grid-drag` | 3/3 | `artifacts/linux-interactive/freex/interaction-validation/20260822T055440Z/interaction-validation.json` |
| `grid-autofit` | 3/3 | `artifacts/linux-interactive/freex/interaction-validation/20260822T055819Z/interaction-validation.json` |

The final outline postcondition retained exact nested levels `2:1, 3:2, 4:2, 5:1, 6:1`,
filter `A1:B7` with `Keep`, filtered rows `3,6`, and reopened values
`Outer2,InnerKeep4,InnerAnchor5,OuterSummary7`. Grid-drag proved autofill `10,20,30,40,50`,
selection-border move with source cleared, and Ctrl-drag copy with source preserved. Grid-autofit
proved column growth, wrapped visible-row growth, and contiguous hidden-row unhide plus sizing.

## Findings And Fixes

The first outline run, grid-drag run, and grid-autofit run were initially blocked by probe defects,
not credited as product passes. The probe waited synchronously when the pointer or window was
already at the requested state, and ImageMagick read screenshots directly from the Docker-mounted
session path until a child became unreapable in `p9_client_rpc`. The probe now skips redundant X11
sync waits and copies analysis inputs to `/tmp` before image processing. The first post-filter
clipboard read also has a bounded retry for the observed focus-handoff race; exact expected values
remain mandatory.

The production failure was in `XlsxFileAdapter.Save`: `Sheet.FilterHiddenRows` was stamped as raw
row `hidden="1"` in addition to the AutoFilter criteria. The saved package therefore conflated
filter-owned visibility with manual/group visibility. Filter-owned rows are now represented only by
AutoFilter criteria; manual and unsupported-native-filter raw hidden state continues through
`Sheet.HiddenRows` and the existing load reclassification path.

Focused regression coverage verifies that a supported worksheet filter does not serialize its
filter-owned row as raw hidden XML, while the existing load/clear and unsupported-filter tests remain
the guardrails for manual and native-only filter visibility. New worksheet and structured-table
save-load-save package tests assert that native-only rows retain raw hidden XML in the second package,
then reload as filter-owned rows again without reappearing in manual `HiddenRows`.

## Initial Failure Artifacts

The initial outline run recorded `package-passed=false` with `package-signature=''` before the
production fix in `artifacts/linux-interactive/freex/interaction-validation/20260822T054344Z/`.
Its retained package inspection showed raw hidden rows `3` and `6`; the final package has
`serialized-hidden=` empty. The initial grid runs retained partial screenshots and process evidence
under sessions on ports `6176` and `6177`; neither was credited as a semantic pass.
