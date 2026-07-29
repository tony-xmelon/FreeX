# Avalonia parity Wave 59

Date: 2026-07-29

## Functional and evidence slices

- **FreeX** now preserves multi-area formula references when physical X11
  focus returns from the grid to the formula editor and the tracked reference
  span has been lost. Both keyboard Add mode and modifier-click use the shared
  comma-separated range-entry planner. A focused Linux/X11 run passed 2/2:
  `=SUM(F5,F7)` calculated `30`, and `=SUM(F5,H7)` calculated `30`.
- **FreeP** now exposes an explicit keyboard route through Slides, Notes,
  Comments, Selection Pane, and Animation Pane. The Linux AT-SPI probe records
  real `object:state-changed:focused` events while X11 sends Tab. It proved all
  five role-qualified targets, their focusable/visible/showing states, and the
  shared traversal order.
- **FreeW** improves the seven Table Properties comparison states with shared
  compact-dialog typography and control metrics plus matched WPF/Avalonia
  focus targets. One state, `tab-column`, moved to a genuine pass. The other
  six remain honestly classified as visual mismatches, but all seven improved
  in changed-pixel ratio and no comparison threshold was weakened.

## Integration review

- The FreeX physical probe originally exposed a production defect:
  references became `=SUM(F5F7)` and `=SUM(F5H7)`, producing `#NAME?`. The
  final implementation recovers the trailing reference span from the editor
  caret and passes the same physical routes with the required comma.
- The recovered-span parser covers ordinary and quoted sheet-qualified
  references. The append planner preserves the full prior quoted qualifier.
- FreeP matching remains role-qualified, so a same-named label cannot satisfy
  a pane target. The five observed roles are `list`, `entry`, `panel`,
  `panel`, and `panel`.
- FreeW's focused family changed from seven focus-bearing genuine mismatches
  to one pass and six semantic-alignment-complete visual residuals. The final
  average is 7.3916% changed pixels and 5.5078 mean channel delta, improved
  from 10.6062% and 6.9875 in the fresh pre-edit captures.
- Concurrent `origin/main` work was merged before final verification. The
  primary dirty checkout was not modified.

## Focused verification

- FreeX shared range-entry planner: 11 passed, 0 failed.
- FreeX Avalonia point/input/editing suites: 38 passed, 0 failed.
- FreeX focused physical Linux/X11 multi-area lane: 2 passed, 0 failed.
- FreeP Avalonia accessibility suites: 8 passed, 0 failed.
- FreeP retained Linux accessibility evidence: 5/5 live controls, 5/5 AT-SPI
  nodes, and five ordered target focus events.
- FreeW Avalonia dialog parity suites: 21 passed, 0 failed.
- FreeW WPF authority Table Properties tests: 3 passed, 0 failed.

## Visual status

The checked-in FreeW canonical comparison now has 170 genuine visual
mismatches, 13 passes, 4 not-applicable rows, and 96 Avalonia extensions.
Table Properties accounts for six of those mismatches. Its remaining
differences are concentrated in text rasterization, control templates,
borders, and anti-aliasing rather than content, state, focus, or principal
geometry.

## Final verification

- Generated-document checks passed after refreshing the cross-app dashboard
  and FreeP command inventory for the integrated source tip.
- Repository preflight passed: 204 JSON files, 258 XML-backed files, 71
  PowerShell scripts, 9 workflows, 122 project files, 88 solution entries,
  20 default-test entries, and all generated-document and conflict-marker
  checks.
- `dotnet build FreeX.slnx --configuration Release -m:1` passed with 0
  warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build
  -m:1` passed across 19 test assemblies: 33,205 passed, 0 failed, and 133
  benchmark or environment-dependent cases intentionally not executed.

## Remaining work

- Continue resolving FreeW's 170 genuine visual mismatches, beginning with
  high-delta routes and the six remaining Table Properties raster/template
  residuals.
- FreeP's OS evidence proves the semantic tree and focus-event order. Actual
  screen-reader speech, announcement wording, and timing remain unverified.
- Authoritative Excel, Word, and PowerPoint application baselines are not
  available on this host. Office-level pixel fidelity therefore remains an
  external evidence boundary; WPF remains the local platform authority.
- Functional and visual parity across all three apps remains an active
  multi-wave objective. Wave 59 closes the three slices above, not the entire
  parity program.
