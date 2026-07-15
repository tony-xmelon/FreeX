# FreeP imported combo-chart fidelity - 2026-07-15

## Scope

The PowerPoint corpus deck `19-chart-labels.pptx`, slide 3, contains a clustered-column and secondary-axis smoothed-line combo chart.

## Changes

- Imported combo charts retain PowerPoint's dense `0..200` primary scale and `0..8000` secondary scale while using the measured PowerPoint plot inset.
- Imported combo gridlines and axis ticks use the dark Office stroke treatment instead of the pale generic chart stroke.
- The secondary-axis overlay uses the imported 3 px smooth-line default.
- The right legend uses measured PowerPoint row spacing and wide chart keys without changing authored-chart legend defaults.

## Verification

- Focused chart tests: `180 passed`, 0 failed.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- WPF render at 1280x720: `2.3670%` mean channel diff on slide 3 against `tools/FreeP.RenderCompare/corpus/pptx-ref/19-chart-labels/slide-03.png`.
- Avalonia render at 1280x720: `2.4691%` mean channel diff on slide 3 against the same reference.
- Slide 2 WPF diff remains `0.7842%`, confirming the pie-chart path is unchanged.

Evidence is retained under `artifacts/freep-combo-fidelity-20260715/` in the worktree, including WPF/Avalonia renders and heatmaps.
