# FreeX Avalonia parity Wave 140: PivotTable Options Display residual

## Scope

This bounded slice addressed the current top valid FreeX visual residual,
`dialog.PivotTableOptions.Display`, triaged at `0.069304` in the retained dialog
summary. The retained WPF and Avalonia images are both opaque `520x500` frames and
show the same default Display state: `PivotStyleLight16`, the same checked row and
column headers, field captions, tooltips, banded rows, and expand/collapse options.
The WPF source and capture history were also checked: the dialog source has not
changed since the Wave 17 Avalonia implementation, so the retained WPF frame is
dated but semantically valid authority for this slice.

## Implementation

The Display-tab constants are explicitly Avalonia host-template compensation, not
shared planner geometry. The fresh baseline showed Avalonia checkbox ink rows at
approximately `125, 145, 165, ...` with a 20 px cadence, while the retained WPF
frame showed approximately `130, 151, 172, ...` with a 21 px cadence. The Avalonia
Display section now applies named spacing, top-inset, and bottom-inset compensation
in `MainWindow.PivotOptions.cs`; WPF remains governed by its existing
`PivotDialogLayout` helpers. The values are documented beside the host constants so
they are not mistaken for cross-host presentation contracts.

## Evidence and metrics

- Fresh Avalonia baseline: `artifacts/wave140-freex-pivot-display-baseline`, exact
  `520x500`, `app_exit=0`, `capture_validated=true`, nonblank.
- Fresh Avalonia after capture: `artifacts/wave140-freex-pivot-display-after`, exact
  `520x500`, `app_exit=0`, `capture_validated=true`, nonblank.
- Fresh post-edit content bounds: checkbox rows are approximately
  `130, 151, 172, ...`; the group box extends to approximately `y=376`, matching
  the WPF authority's `y=375` bottom envelope. The fresh frame remains the same
  semantic fixture state as the retained WPF frame.
- Isolated parity compare against the retained WPF authority improved from
  `3.6799076797%` before to `2.8928129085%` after, a concrete reduction of
  `0.7870947712` percentage points (about `21.39%` relative). The original retained
  triage score `0.069304` is not relabeled as an after score because the summary
  generator and isolated parity comparer use different metrics.

## WPF capture limitation

The current WPF Release host built successfully and a targeted capture was
attempted with `--parity-capture-target dialog.PivotTableOptions.Display`. The
process exited `0`, but the capture manifest reported `0/7` captured surfaces and
rejected every frame as fully transparent. No blank WPF frame was promoted or used
to tune Avalonia. The retained Wave 17 WPF PNG remains the authority until the WPF
render harness produces a nonblank frame.

The isolated comparer itself exits nonzero because the reduced capture directories
do not contain the full name-box surface contract; its generated Display entry has
`hard regressions=0` and is the source of the percentages above.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotOptionsPlannerTests"` - 18 passed after the final ownership refactor.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotOptionsParitySourceTests"` - 1 passed after the final ownership refactor; the guard checks explicit Avalonia compensation ownership rather than numeric literals.
- `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj --configuration Release` - 0 warnings, 0 errors.
- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release` - 0 warnings, 0 errors.
- Fresh Docker/Xvfb Avalonia baseline and after captures - exact-size, nonblank, `app_exit=0`.
