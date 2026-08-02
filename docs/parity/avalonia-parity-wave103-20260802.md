# Avalonia parity Wave 103

Date: 2026-08-02

## Scope

Wave 103 advances one concrete parity slice in each application, keeps the
toolkit-neutral presentation layer authoritative, and validates the FreeX UI
change in the Linux Docker/X11 harness.

## FreeX

The Avalonia host now exposes the active sheet's slicers and timelines in the
same right-side task-pane workflow as WPF. The pane:

- uses `SlicerTimelinePanePlanner` for visible filters, tiles, selection
  semantics, active-filter state, date normalization, and source mapping;
- supports plain, Ctrl/Meta, and Shift slicer selection, clear filter, timeline
  apply/clear, undo refresh, close persistence, Escape, Tab cycling, and the F6
  shell focus cycle;
- preserves the existing native on-grid slicer/timeline overlays and timeline
  granularity command route;
- uses the existing shared localization keys for visible and accessibility
  text; and
- resets dismissed pane state whenever the workbook session is replaced, so a
  close in one workbook does not hide the pane in the next workbook.

The Linux pivot task-pane selector previously launched the demo CSV even though
its probe requires the real pivot workbook. `pivot-field-list` now shares the
same validated `.xlsx` fixture setup as `pivot-table-details-double-click`.

## FreeW

Backstage Export action order and measured WPF geometry now come from
`BackstageExportPanePlanner`. Avalonia consumes the shared heading, description,
section, action-row, typography, and spacing metrics. PDF, XPS, and editable
format actions retain their callbacks while following the WPF authority order.

Fresh paired evidence used the same `560x600` target for both toolkits:

| Metric | Checked-in baseline | Wave 103 | Change |
| --- | ---: | ---: | ---: |
| Changed pixels | 61,251 / 336,000 | 45,506 / 336,000 | -15,745 |
| Changed-pixel ratio | 18.2295% | 13.5435% | -4.6860 pp |
| Mean channel delta | 14.8256 | 11.5055 | -3.3200 |
| Perceptual hash distance | 14 | 12 | -2 |
| Semantic difference | `action-button-order` | none | resolved |

Both captures passed content gates. The route remains a
`genuine-visual-mismatch`; this wave does not relabel residual toolkit text and
native-control rasterization differences as parity.

The raw temporary capture directory was
`C:\Users\anton\AppData\Local\Temp\freex-wave103-final`; the metric table above
is retained evidence and the temporary directory is cleanup-owned.

## FreeP

WPF and Avalonia now consume `InlineTableLogicalGridPlan` for inline rich-text
table ownership, source-cell mapping, navigation, and appended-row structure.
The shared planner:

- emits one editable stop for each logical anchor;
- skips HMerge and VMerge continuation cells;
- preserves compact `GridSpan` source indices;
- resolves covered grid positions to their anchor;
- bounds Shift+Tab at the first cell; and
- creates a structurally valid row when Tab leaves the final logical cell.

Avalonia keeps renderer-specific paint and hit geometry while using the shared
logical ownership map. WPF now creates editors only for logical anchors and
commits text to the correct physical source cell.

## Verification

Focused tests:

- FreeX production slicer/timeline pane: 1 passed.
- FreeX Linux pivot fixture source contract: 1 passed.
- FreeP shared logical-grid planner: 4 passed.
- FreeP WPF merged-cell editor/source mapping: 1 passed.
- FreeP Avalonia inline-table keyboard navigation: 1 passed.
- FreeW presentation Export tests: 16 passed.
- FreeW Avalonia Backstage tests: 37 passed.
- FreeW WPF and Avalonia visual harness builds: zero warnings and zero errors.

Repository gates:

- `tools/Test-RepositoryPreflight.ps1`: passed, including generated parity
  evidence and conflict-marker checks across 10,374 text files.
- `dotnet build FreeX.slnx --configuration Release`: passed with zero warnings
  and zero errors.
- `FreeX.DefaultTests.slnx`: all 19 runnable test assemblies were accounted for,
  with 35,359 passed, zero failed, and 133 skipped/not executed; the fixtures
  project contains no tests. Final merged-head validation used bounded
  per-project batches after the monolithic wrapper exited while Core IO was
  active. One clipboard-isolated host test failed once in the shared batch,
  then passed both alone and in the clean full-host rerun. Core IO passed 5,122
  with 56 benchmark-only skips; Core Model passed 5,549 with 40 benchmark-only
  skips; Integration passed 608 with one skip; ParityCompare passed 30/30.
- Linux Docker/X11 `pivot-field-list`: 2/2 physical probes passed against
  `FreeX_wave50_pivot_fields.xlsx` at 1280x820 and 96 DPI. The harness-owned
  container on port 6903 stopped normally.

## Remaining

The overall parity goal remains active. FreeW Export still has a measurable
13.5435% cross-toolkit visual delta, and the generated family dashboards retain
other genuine visual and deeper workflow candidates. Wave 103 proves these
three slices; it does not claim whole-product parity.
