# Avalonia parity Wave 101 integration

Date: 2026-08-01

## Scope

Wave 101 resumes the active function-first Avalonia/WPF parity program with one bounded production
slice in each app. The wave also integrates the FreeW work that reached `main` while the slices were
in progress.

### FreeX: production Advanced Filter workflow

- The real Avalonia Data > Advanced Filter dialog is now covered through all three worksheet range
  pickers: List range, Criteria range, and Copy to.
- The production-host regression exercises Enter to accept a pointed range, Escape to restore the
  previous value, Copy to another location, unique-record extraction, resulting worksheet values,
  selected output range, undo, and redo.
- Avalonia now remembers the most recently applied in-place Advanced Filter through a shared
  presentation contract and re-runs it from Data > Reapply after source values change, matching the
  existing WPF behavior.

### FreeW: reproduced host parity guards

- Six previously reported host parity failures were reproduced before editing and repaired without
  weakening their assertions.
- Export and ribbon messages route through the shared dialog helper; FreeP's WPF backstage default
  route delegates to the shared pane composer.
- WPF and Avalonia chart hosts consume the shared signed value-axis plan.
- SmartArt contextual commands are backed, and five missing command icons now have direct SVG
  assets in the WPF authority set.

### FreeP: merged inline rich-text tables

- Avalonia inline-table rendering, hit testing, and bounds lookup now honor horizontal and vertical
  merged cells (`GridSpan`, `RowSpan`, `HMerge`, and `VMerge`).
- Covered grid coordinates resolve to their top-left model anchor through the shared table-grid
  geometry planner, so paint, pointer hit testing, and cell-editor placement use one geometry.
- Both explicit continuation-cell imports and compact imported row representations are covered.

The upstream sync also brings in FreeW Shadowed Squares page-border rendering and repeating-section
content-control package retention.

## Verification

- Merged FreeX Avalonia production/dialog checks: 8/8 passed.
- Merged FreeP Avalonia rendering checks: 219/219 passed.
- FreeP shared presentation table/geometry checks in the worker branch: 107/107 passed.
- Merged FreeW repaired host checks: 8/8 passed.
- Worker builds for the affected FreeP renderer, FreeW Avalonia app, and FreeP WPF host completed
  with zero warnings and zero errors.
- Repository preflight passed across 10,311 text files after refreshing the affected generated
  FreeP whole-window and FreeW command-inventory evidence.
- The serialized 89-project Release build passed with zero warnings and zero errors.
- The default non-UI matrix passed every project except one stale FreeP source assertion and three
  order-sensitive FreeX clipboard cases. The source assertion was corrected to the shared-controller
  contract and its full project then passed 1,886/1,886. Each clipboard case passed 1/1 in isolation;
  a subsequent standalone Host Logic run passed 1,487 with four expected skips and exposed one
  different clipboard-flavor case, which also passed 1/1 in isolation.
- The Linux Docker smoke passed native workbook edit/save/reopen, Xvfb application launch,
  accessibility/dialog probes, and produced a nonblank 1140x740 FreeX screenshot.

## Remaining work

- FreeX has production-host evidence for Advanced Filter range pointing and reapply, but the wider
  cross-feature physical workflow and visual backlog remains open.
- FreeW's repaired guards close concrete functional/source gaps; the broader dialog and whole-window
  visual mismatch inventory remains open.
- FreeP inline rich-text table merges are now geometrically correct in Avalonia, but broader nested
  table combinations, imported Office corpora, and exact PowerPoint text metrics still need deeper
  physical and visual evidence.
- Authoritative Microsoft Office PNG baselines remain unavailable in the generated cross-app
  dashboard inputs, so app-owned WPF/Avalonia comparisons cannot establish Office pixel parity.

Wave 101 advances the active parity goal but does not claim complete Avalonia/WPF parity.
