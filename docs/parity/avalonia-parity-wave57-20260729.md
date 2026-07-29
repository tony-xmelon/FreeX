# Avalonia parity Wave 57

## Functional slices

- **FreeX** now shares Excel-style 3-D formula point-entry between WPF and
  Avalonia. A first sheet-tab click, Shift-click on the ending sheet, and a
  pointed cell, range, row, or column produce references such as
  `Sheet1:Sheet3!A1`. The shared state/planner also preserves quoted sheet
  names, A1 and R1C1 notation, F4 cycling, and drag or keyboard reference
  extension.
- **FreeW** now uses one rich floating-shape text layout plan in both hosts.
  Per-run family, size, bold, italic, underline, strikethrough, and color are
  rendered with shared paragraph, wrapping, caret, hit-test, drag-selection,
  and clipping geometry, including rotated text.
- **FreeP** now uses one accessibility contract for the 11 paired live panes:
  Slides, Notes, Comments, Accessibility, Alt Text, Reading Order, Proofing,
  Media Captions, SmartArt Text, Selection, and Animation. Live WPF and
  Avalonia controls receive the same pane/item IDs, names, help text, order,
  selection, and visibility state.

## Integration review

- FreeX review removed stale 3-D span state after reference completion,
  preserved spans through drag/extension, and guarded programmatic text and
  inline-caret abandonment paths.
- FreeW review kept paragraphs outside the selected range unchanged, aligned
  caret/highlight metrics with visible rendering, preserved outer shape
  effects while clipping inner text, and handled CRLF and overlong-word
  wrapping deterministically.
- FreeP review refreshed snapshots from live MainWindow state, replaced
  dummy-only coverage with live control checks, removed duplicate comment
  metadata, preserved section-aware order updates, and refreshed generated
  whole-window source hashes.
- The all-up lane exposed a stale FreeP source guard that still expected the
  old one-argument slide-section helper. It now recognizes the accessibility
  ordinal argument used by the shared contract.
- A concurrent default run produced one transient FreeX clipboard/navigation
  cache failure. The unchanged original test then passed 20/20 in isolation,
  and the complete lane passed with project parallelism disabled. A proposed
  logically equivalent production rewrite and weaker test were rejected.

## Verification

- Generated parity documentation: current.
- Repository preflight: passed, including JSON, XML-backed resources,
  PowerShell, workflows, SDK/solution readiness, packaging, generated docs,
  and conflict-marker checks.
- `dotnet build FreeX.slnx --configuration Release`: 0 warnings, 0 errors.
- Serial default non-UI lane: 33,152 passed, 0 failed, 133 skipped or not
  executed across 19 test assemblies.
- Focused FreeX lanes: 29 shared planner tests, 6 WPF point-mode tests, and
  7 Avalonia point-mode tests passed.
- Focused FreeW lanes: 27 presentation tests, 25 WPF tests, and 26 Avalonia
  tests passed.
- Focused FreeP lanes: 3 shared planner tests, 1 WPF host test, and
  2 Avalonia host tests passed.
- FreeP generated dialog/pane evidence: 28/28 passed across 123 PNGs.
- FreeP whole-window evidence: 33/33 paired, with no declared mismatch or
  capture limitation.

## Linux Docker evidence

All lanes used a 1280x820 desktop at 96 DPI and stopped only their
harness-owned container.

- FreeX physical X11 lane: 24/24 passed.
  Evidence:
  `artifacts/linux-interactive/freex/interaction-validation/20260729T163107Z/`.
- FreeW family physical X11 lane: 37/37 passed.
  Evidence:
  `artifacts/linux-family-interactive-wave57/freew/sessions/20260729T163745907Z/family-validation/`.
- FreeP family physical X11 lane: 24/24 passed.
  Evidence:
  `artifacts/linux-family-interactive-wave57/freep/sessions/20260729T164011448Z/family-validation/`.

These baselines prove broad physical keyboard, pointer, file-surface, and
dialog regression safety. They are not feature-specific physical proof for
every new Wave 57 path.

## Remaining work

- FreeX 3-D point-entry still needs a dedicated manual/physical UI probe across
  multiple live sheets.
- FreeW rich shape text still needs authoritative Office pixel/golden
  comparison, especially for mixed fonts, rotated text, and effect clipping.
- FreeP live metadata still needs an operating-system screen-reader smoke pass.
- Cross-app visual parity still needs authoritative WPF/Office image comparison
  for surfaces where current generated evidence proves pairing but not exact
  pixel fidelity.
