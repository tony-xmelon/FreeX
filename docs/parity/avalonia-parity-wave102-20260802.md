# Avalonia parity Wave 102

Date: 2026-08-02

## Scope

Wave 102 closes one functional slice in each application while keeping shared
presentation contracts authoritative where both desktop toolkits render the
same surface.

## FreeX

Reapply now executes every active AutoFilter column together with the remembered
in-place Advanced Filter as one `CompositeWorkbookCommand`. The operation is one
undo/redo unit, rolls back atomically on failure, preserves the current selection,
and recalculates formulas after row visibility changes. It no longer replays the
worksheet sort state because the WPF route treats Reapply as filter-only.

Production-host coverage applies two AutoFilter columns and an Advanced Filter,
edits the data, invokes the real Reapply route, and verifies combined visibility,
single-step undo/redo, selection preservation, and failure atomicity.

## FreeP

Inline rich-text table Tab and Shift+Tab navigation now follows logical cell
anchors rather than physical grid slots. Covered horizontal and vertical merge
slots are skipped, compact `GridSpan` rows retain the correct source-cell mapping,
and Tab from the final logical cell appends and persists a structurally valid row.

## FreeW

The Backstage Open pane now gets its heading, description, search, tab, and action
row geometry from `BackstagePaneSurfacePlanner.OpenPaneVisualMetrics`. WPF and
Avalonia consume the same values while retaining toolkit-native controls and
their existing actions, tab selection, scrolling, automation, and focus behavior.

Fresh 560x600 paired evidence for `backstage-open.open`:

| Metric | Checked-in baseline | Wave 102 | Change |
| --- | ---: | ---: | ---: |
| Changed pixels | 70,176 | 62,982 | -7,194 |
| Changed-pixel ratio | 20.8857% | 18.7446% | -2.1411 pp |
| Mean absolute channel delta | 18.104 | 16.413 | -1.691 |

The route remains classified as `genuine-visual-mismatch`; this wave does not
claim complete native-template or text-rasterization parity.

## Verification

- FreeX Advanced Filter/Reapply and AutoFilter recalculation tests: 5 passed.
- FreeP focused merged-table navigation tests: 14 passed.
- FreeP full Avalonia rendering suite: 221 passed.
- FreeW Avalonia Backstage tests: 36 passed.
- FreeW shared Backstage planner tests: 14 passed.
- FreeW WPF and Avalonia Open captures: 1/1 each; both passed content gates.
- Repository preflight passed, including generated evidence and conflict-marker
  checks across 10,324 text files.
- Full `FreeX.slnx` Release build passed with zero warnings and zero errors.
- `FreeX.DefaultTests.slnx` passed every non-UI project; benchmark-only skips
  remained expected.
- The isolated Linux Docker/Xvfb smoke passed all seven production-app flows:
  launch, cell entry, Format Cells, Find/Replace, Go To, name-box navigation,
  and final app stability.
