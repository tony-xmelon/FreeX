# FreeP chart-label rendering probes rejected - 2026-07-18

## Scope

Fresh PowerPoint COM capture of `19-chart-labels.pptx` covers a style-2
column chart with value labels, a pie chart with percent labels, and a
column-plus-line secondary-axis chart with value labels. The visual residual
is concentrated in WPF chart-label/grid raster and small Cartesian plot
registration differences; Avalonia is already materially closer on this
corpus.

## Matched baseline

| Slide / host | Baseline |
| --- | ---: |
| WPF slide 1 column labels | 1.5195% |
| WPF slide 2 pie labels | 0.6895% |
| WPF slide 3 combo labels | 1.6685% |
| Avalonia slide 1 | 0.5432% |
| Avalonia slide 2 | 0.4702% |
| Avalonia slide 3 | 0.8040% |
| Avalonia vs PowerPoint slide 1/2/3 | 1.4722% / 0.6709% / 1.4505% |

Raw bar and grid scans showed PowerPoint's style-2 labeled charts use slightly
wider bar footprints and a single dark grid row. These observations were
diagnostic, not proof of a shared geometry owner.

## Rejected probes

1. WPF chart-label `TextFormattingMode.Display` -> `Ideal`: WPF became
   `1.5298% / 0.6694% / 1.6814%` on slides 1-3. The typography change did not
   improve the complete sequence.
2. Re-enabled the existing style-2 plot-frame correction when data labels
   are present: WPF became `2.4007% / 0.6895% / 1.6685%`; the labeled column
   chart regressed materially.
3. Imported Cartesian grid-line offset `0.5` -> `1.0` DIP: WPF became
   `1.5167% / 0.6895% / 1.9447%`; the small slide-1 gain was outweighed by
   the combo-chart regression. Avalonia slide 1 also moved `0.5432% ->
   0.5463%`.

All probes used fresh three-slide PowerPoint exports and were reverted. No
chart-label product calibration was accepted.

## Process rule

Do not generalize a chart-frame or grid registration from a single labeled
chart. Gate value-label, pie-label, combo-axis, and complete-sequence ROIs
independently; a local raster or one-slide gain is insufficient when the
shared chart planner owns several chart families.

## Verification

- `FreeP.RenderCompare` Release probe builds: 0 warnings, 0 errors.
- Focused chart presentation tests remain the required post-restore check.
- Product source restored to the accepted label/frame/grid baseline.
