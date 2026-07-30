# FreeX Wave72: PivotTable value-cell double-click

## Scope

This slice closes one functional WPF/Avalonia gap in the FreeX worksheet interaction path:
double-clicking a rendered PivotTable value cell must open the PivotTable detail worksheet before
the ordinary inline cell editor is entered.

The slice deliberately does not change the Wave71 whole-range formula point-mode behavior.

## Authority audit

WPF is the authority for the event ordering in
`src/FreeX.App.Host/MainWindow.Selection.cs`. Its cell double-click path calls
`TryShowPivotTableDetails(showMessage: false)` first and calls `EnterEditMode` only when that
operation returns false. The WPF implementation resolves the selected PivotTable cell through
`PivotUiPlanner.ResolveShowDetailsTarget`, executes `DrillDownPivotTableCommand`, and refreshes the
active worksheet after the detail sheet is created.

Before Wave72, Avalonia's cell double-click path in `src/FreeX.App.Avalonia/MainWindow.cs` always
called `BeginInlineCellEdit`. Avalonia already had the shared planner and Core drill-down command,
and its ribbon Show Details route already used them, so this was a host interaction omission rather
than a missing model capability.

## Implementation

- Added `TryShowPivotTableDetailsFromDoubleClick` to the Avalonia Pivot Analyze partial.
- Reused the shared `PivotUiPlanner.ResolveShowDetailsTarget` and
  `DrillDownPivotTableCommand` through `WorkbookSession.ExecuteReviewCommand`.
- Routed both Avalonia cell double-click event paths through the WPF-equivalent pivot-first fallback:
  successful drill-down ends the event; a non-PivotTable cell continues into inline editing.
- Added a short-lived one-shot suppression guard because Avalonia can surface the same physical
  double-click through both the pointer click-count path and `DoubleTapped`. This prevents a
  successful drill-down from being followed by an inline editor opened by the second event.

## Verification

Focused test project:

```text
tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj
```

Tests:

- `FreeXWave72PivotTableDoubleClickTests.PivotValueDoubleClick_DrillsToDetailsBeforeInlineEditing`
  seeds the deterministic Category/Quarter/Amount pivot, selects rendered value cell `F4`,
  invokes the same host seam, and verifies a `Detail...` sheet, copied detail rows, and no inline
  editor.
- `FreeXWave72PivotTableDoubleClickTests.DoubleClickSourceContract_PreservesWpfPivotPrecedenceAndSingleDispatch`
  checks the WPF authority marker, the shared Avalonia planner/command path, both Avalonia event
  routes, and the duplicate-event suppression contract.

Exact command:

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~FreeXWave72PivotTableDoubleClickTests" --logger "console;verbosity=minimal"
```

Result: 2 passed, 0 failed.

## Physical selector

The `pivot-table-details-double-click` selector extends the existing Linux/X11 runner:

1. Open the deterministic `FreeX_wave50_pivot_fields.xlsx` fixture.
2. Physically double-click rendered PivotTable value cell `F2`.
3. Read detail `A1:C2` through X11 clipboard input and require
   `Region|Category|Amount` plus `North|Hardware|100`.
4. Save and inspect the OOXML package for a second sheet named `Detail` with the same values.
5. Capture before, immediately-after-double-click, and readback screenshots plus a semantic
   postcondition transcript.

The managed and runner contracts are covered. The selector still needs its physical Docker run
before the real Linux input-delivery residual can be closed.
