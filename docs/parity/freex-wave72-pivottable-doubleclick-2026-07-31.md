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

## Residual and physical selector

The managed/headless contract is covered. A physical Linux/X11/VNC probe was not run in this slice.
The proposed selector is `pivot-table-details-double-click`:

1. Open the deterministic pivot fixture with Category, Quarter, and Amount source columns.
2. Double-click rendered value cell `F4` in the PivotTable.
3. Assert that the active sheet name starts with `Detail`, detail `A1:C2` reads
   `Category|Quarter|Amount` and `A|Q1|10`, and no inline cell editor is visible.
4. Capture before, pointer-double-click, and after screenshots plus workbook readback.

The remaining risk is framework/input delivery on the real Linux surface: the managed route is
covered, but the selector still needs to prove that the physical double-click reaches the Avalonia
cell event path and that the detail-sheet transition is observable through the harness.
