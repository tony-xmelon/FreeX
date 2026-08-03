# Avalonia parity Wave128 integration

Date: 2026-08-03

## Integrated slices

- FreeX moved Create Table range parsing and dialog layout values onto shared
  presentation contracts, aligned pointing, validation, focus, Enter/Escape,
  header-checkbox, and styled-table behavior, and added direct current-source
  WPF capture support for `dialog.CreateTable`.
- FreeW added a shared focus contract for Compare Documents, Properties, Table
  Formula, and Zoom. Both hosts now use the same initial and validation focus
  targets and select-all policy across the 13 canonical states in that cluster.
- FreeP preserves every authored `m:aln` position in an equation-array row,
  keeps nested alignment points scoped to their nearest `m:eqArr`, and lays out
  multiple alignment columns through the renderer-neutral math box plan.

## Evidence

- FreeX Create Table was freshly captured from current WPF and Linux Avalonia
  source at 360x190 and 96 DPI. Its triage score improved from `0.085779` to
  `0.044631`; sample delta improved from `0.039980` to `0.022440` and
  non-background delta from `0.041296` to `0.019167`.
- The merged FreeX visual summary retains 94 WPF and 94 Avalonia surfaces, zero
  missing pairs, zero nonblank failures, zero logical-size mismatches, and zero
  expected-size mismatches. The highest residual remains Format Cells Alignment
  at `0.086598`.
- FreeW refreshed all four affected routes from current source. All 13 focus
  rows now have `semanticDifference: null` while retaining the honest
  `genuine-visual-mismatch` classification. Four `action-button-order` rows are
  the remaining canonical semantic cluster.
- FreeP parser, layout, WPF host, and Avalonia renderer tests exercise multiple
  authored alignment points and nested-context locality through the same shared
  model and draw plan.

## Verification

- Worker-focused verification passed: FreeX 118 focused tests plus preflight
  and a warning-free Release build; FreeW focus, host-boundary, inventory,
  freshness, and dashboard checks; FreeP 323 parser/layout tests plus 8 WPF and
  8 Avalonia parity tests.
- The combined dialog visual summary and cross-app dashboard were regenerated
  after all three commits and their check modes passed.
- Final repository preflight passed, and the Release solution build completed
  with zero warnings and zero errors.
- The serial default non-UI lane produced 21 TRX files covering 36,306 tests.
  It initially exposed one stale Create Table source guard and one transient
  clipboard-isolation failure. After updating the guard, both affected
  assemblies passed in full: 2,020 Avalonia tests and 1,498 Host Logic tests,
  with four intentional skips and no remaining failures.

## Residuals

- FreeX visual work now starts with Format Cells Alignment and Pivot Table
  Options Display; Create Table is no longer a top-ten visual outlier.
- FreeW retains 155 paired visual mismatches and the four-row
  `action-button-order` semantic cluster. Avalonia-only extension rows remain
  evidence gaps rather than proof of missing WPF implementation.
- FreeP still needs broader OfficeMath spacing/default coverage and
  PowerPoint-authoritative raster baselines beyond the shared renderer tests.
