# FreeP chart data-label text properties - 2026-07-19

## Scope

PowerPoint stores authored data-label formatting in `c:dLbls/c:txPr`.
FreeP previously read the label visibility and number-format fields but dropped
the authored text properties on read and could not write them back.

## Change

- `ChartDataLabels.TextStyle` now retains authored size, bold, italic, color,
  and typeface metadata.
- The PPTX reader and writer preserve the `c:txPr` payload in schema order.
- The shared chart planner applies the label style to renderer-neutral plans.
- WPF and Avalonia consume the planned typeface, weight, italic state, size,
  and color; slide cloning deep-copies the label style.

## Evidence

The established current `19-chart-labels` PowerPoint corpus already carries
an 18pt label text-properties block. A fresh Release render remained unchanged
against the persistent COM baseline: WPF slide diffs were `1.5195%`, `0.6240%`,
and `1.6685%`; no visual control regressed.

## Verification

- `ChartDataLabelsTests`: 41/41.
- `ChartBaselineCorpusTests` + `ChartRenderPlannerTests`: 200/200.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh three-slide PowerPoint comparison completed at 1280x720.
