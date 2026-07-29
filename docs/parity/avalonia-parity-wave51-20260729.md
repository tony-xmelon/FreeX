# Avalonia parity wave 51

Date: 2026-07-29

## Closed slices

- FreeX: AutoFilter apply, change, and clear now explicitly recalculate the
  workbook in Avalonia, matching WPF for `SUBTOTAL` and `AGGREGATE` formulas
  that depend on hidden rows.
- FreeX: restored the WPF `Alt+Down` priority order: a real data-validation
  dropdown wins first, an AutoFilter header opens the AutoFilter flyout second,
  and the ordinary adjacent-text pick list is the final fallback. The shared
  planner no longer renders a permanent validation arrow for a plain text cell.
- FreeX: an untouched custom-criteria editor no longer seeds `text=` into the
  AutoFilter result and override checklist selections. The Linux checklist can
  now apply North, change to South, and clear through the production flyout.
- FreeW: moved 26 Drawing Format command rows from profile-shape-only evidence
  to the shared command profile and implemented Avalonia execution for Change
  Shape, Shape Fill, Shape Outline, Shape Effects, Edit Shape, and Text
  Direction menus. The generated inventory now has 934 rows, with 484 shared,
  402 profile-shape-only, and no actionable command gaps.
- FreeP: the Avalonia Review Comments pane now preserves the user's requested
  open state across temporary context changes, matching the WPF pane lifecycle.
- Evidence: refreshed the FreeW command inventory, FreeP whole-window manifest,
  and cross-app parity dashboard. Repository preflight confirms all generated
  parity documents are current.

## Validation

- Focused FreeW command coverage passed 25/25.
- Focused FreeP Review Comments lifecycle coverage passed 1/1.
- Focused shared dropdown planner/source coverage passed 15/15.
- Focused FreeX Avalonia AutoFilter/dropdown coverage passed 14/14.
- Exact WPF adjacent-text pick-list parity coverage passed 2/2.
- Physical Linux/X11 AutoFilter report:
  `artifacts/linux-interactive/freex/interaction-validation/20260729T040130Z/interaction-validation.json`
  passed 1/1. The real flyout changed the displayed
  `SUBTOTAL(109,B2:B3)` result `30 -> 10 -> 20 -> 30`.
- Repository preflight passed.
- Full Release solution build passed with 0 warnings and 0 errors.
- Default non-UI lane passed 33,063 executed tests with 0 failures; 133 existing
  opt-in/performance tests were skipped.
- A broader focused WPF Data Validation/AutoFilter sweep passed 134/136. Its two
  failures are unrelated stale expectations already contradicted by current
  production behavior: one expects the retired single AutoFilter reapply
  factory instead of the current per-column dictionary, and one expects a
  10,001-item validation-source boundary to be rejected. The branch-specific
  WPF pick-list coverage and the complete default lane both pass.

## Remaining work

- FreeX generated command/dialog routing is complete for current inventories,
  but pixel-level and workflow-complete parity still requires continuing Linux
  interaction and Windows/Avalonia visual comparison as residuals are found.
- FreeW still needs authoritative Word PNG comparisons, Linux screenshot
  evidence for rotated text, and deeper direct grouped-child editing evidence.
- FreeP still needs PowerPoint-authoritative Animation Pane visual/playback
  baselines, broader chart/SmartArt/math/media comparisons, and real hardware
  microphone/camera validation.

This wave closes concrete functional and physical gaps; it does not claim 100%
Avalonia/WPF parity.
