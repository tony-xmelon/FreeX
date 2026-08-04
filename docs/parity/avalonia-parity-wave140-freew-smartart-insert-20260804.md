# FreeW Insert SmartArt Geometry, Wave 140

The Insert SmartArt dialog now consumes one planner-owned label from
`SmartArtDialogPlanner` in both hosts:

`Diagram text (one item per node - use Add/Remove to manage):`

This removes the WPF/Avalonia semantic text mismatch without changing SmartArt
construction, keyboard behavior, default/cancel actions, or automation names.
ASCII punctuation keeps the shared source stable across the WPF and Avalonia
hosts.

## Bounds and Metrics

The retained WPF authority remains `x14,y18,517x305`. The audited Avalonia
baseline was `x14,y18,518x294`, with changed ratio
`0.09716071428571428` against that authority.

Fresh Avalonia initial and populated captures both passed the nonblank content
gate at `560x600` and measured `x14,y18,518x294`. The fresh WPF initial and
populated runs were built and attempted after the source change, but both were
rejected by the harness as zero-painted black output. Those invalid frames were
not promoted and no fresh changed ratio was computed from them.

## Verification

- WPF visual harness Release build: passed, 0 warnings, 0 errors.
- Avalonia visual harness Release build: passed, 0 warnings, 0 errors.
- `ChartMediaDialogPlannerTests`: 8 passed.
- `MediaDialogParitySourceTests`: 15 passed.
- Fresh Avalonia SmartArt initial/populated captures: 2 captured, 2 passed content gates.
- Fresh WPF SmartArt initial/populated captures: 0 captured; both rejected as blank.
