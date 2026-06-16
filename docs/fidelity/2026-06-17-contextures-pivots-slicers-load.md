# Contextures pivots+slicers total load failure — fix

**Date:** 2026-06-17
**Branch:** `worktree-agent-aa17b5b24f0d03398`
**File that failed to load:** `test-corpus/public/contextures/02_pivots-slicers_region-sales.xlsm`
(4 pivot tables, 3 pivot caches, 2 slicers, 3 Tables, named ranges, VBA)

## Symptom

The entire workbook failed to load:

```
System.FormatException: Invalid range notation: 'D6'
   at FreeX.Core.Model.GridRange.Parse(String rangeText, SheetId sheet)  GridRange.cs:96
```

The sibling contextures files load fine: `01_pivot-tables_customer-products.xlsx`
(pivots, no slicers) and `03_table-chart-slicers_task-tracker.xlsx` (slicers, no
pivots). The crash is in a pivot-table path, not slicer-specific.

## Root cause

Full stack (captured via a temporary, since-reverted debug print in the
SheetFidelity harness):

```
GridRange.Parse(...)                                          GridRange.cs:96
XlsxPivotTableReader.ToPivotTableModel(pending, sheetId)      XlsxPivotTableReader.Models.cs:9
XlsxPivotTableReader.PendingPivotTableModel.ToPivotTableModel XlsxPivotTableReader.Models.cs:174
XlsxFileAdapter.LoadCore(...)                                 XlsxFileAdapter.cs:561
XlsxFileAdapter.LoadWithWarnings(...)                         XlsxFileAdapter.cs:60
```

`XlsxPivotTableReader.ToPivotTableModel` parses the pivot table's target
location with `GridRange.Parse(pending.TargetReference, sheetId)`.
`TargetReference` is read from the pivot definition's
`<location ref="...">` attribute (`XlsxPivotTableReader.cs:222`).

In OOXML, a pivot table's `location/@ref` can legitimately collapse to a
**single cell** (e.g. `D6`) — Excel emits this for an empty / freshly-anchored
pivot whose body has no rows/cols/data yet, or one parked at a single anchor.
One of the four pivots in this workbook has `<location ref="D6">`.

`GridRange.Parse` is strict: it requires the `A1:B2` colon separator and throws
`FormatException` for a bare single cell. Because pivot loading is not wrapped
in a per-feature try/catch at this layer, that exception propagated all the way
out and aborted the whole load.

## Fix

Two-line behavioural change, fixed at the right layer (the caller that knows a
single-cell ref is legal), keeping `GridRange.Parse` strict so genuinely
malformed references elsewhere still surface as errors:

1. **New helper** `GridRange.ParseCellOrRange(string, SheetId)` in
   `src/FreeX.Core.Model/GridRange.cs` — if the text has no `:` it parses a
   single `CellAddress` and returns a degenerate 1x1 range (`D6` -> `D6:D6`);
   otherwise it delegates to the existing strict `Parse`.
2. **Pivot reader** `src/FreeX.Core.IO/XlsxPivotTableReader.Models.cs:9` now
   calls `GridRange.ParseCellOrRange(pending.TargetReference, sheetId)` instead
   of `GridRange.Parse`.

`GridRange.Parse` itself was **not** loosened, so single-cell refs are accepted
only where they are valid (pivot location). The `:`-presence check mirrors the
existing convention (`CellAddress.TryParse` for cells, `Parse` split on `:` for
ranges).

## Tests (TDD: red -> green)

- `tests/FreeX.Core.Model.Tests/ModelTests.GridRange.cs` — three unit tests for
  `ParseCellOrRange` (single cell -> 1x1; multi-cell normalised; still throws on
  `A1:B2:C3`). Compile-failed before the API existed; pass after.
- `tests/FreeX.Core.IO.Tests/XlsxPivotSingleCellLocationLoadTests.cs` —
  integration regression: builds a real pivot package, rewrites its
  `<location ref>` to `D6`, loads, and asserts the workbook loads and the pivot
  survives with a degenerate `D6:D6` target range. Threw `FormatException`
  before the fix; passes after.

A self-contained synthetic fixture is used (rather than the untracked
contextures file) so the regression test runs on the default gate regardless of
corpus-file availability. The real file was confirmed separately via the
harness (below).

## Verification

- `dotnet build FreeX.slnx -c Release` — Build succeeded, 0 warnings, 0 errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`:
  - All projects green **except** the documented pre-existing, unrelated failure
    `FreeX.App.Host.Tests.WorksheetContextMenuPlannerTests.BuildCommands_SourceKeepsStateCacheOnHotPath`
    (its source files are byte-identical to `origin/main` — `git diff --quiet
    origin/main` reports no difference; not caused by this change).
  - Representative passing counts: Core.Model 3965, Core.IO 2604, Core.Formula
    2938, Core.Calc 781, App.Services 1080, App.Host.Logic 1514 (1 pre-existing
    fail), Integration 78, Avalonia 58, Ribbon 315.
- Harness (`tools/FreeX.SheetFidelity`, rebuilt) on
  `02_pivots-slicers_region-sales.xlsm`:
  - **Before:** `Section 1 LOAD — Status: EXCEPTION — System.FormatException:
    Invalid range notation: 'D6'`
  - **After:** `Section 1 LOAD — Status: SUCCESS`, no load warnings. Structural
    inventory shows the pivots (Pivots sheet: 3 pivots; Lists sheet: 1 pivot)
    and tables loaded. (Macros surface as expected unsupported features.)

## Files changed

- `src/FreeX.Core.Model/GridRange.cs` (add `ParseCellOrRange`)
- `src/FreeX.Core.IO/XlsxPivotTableReader.Models.cs` (use it for pivot location)
- `tests/FreeX.Core.Model.Tests/ModelTests.GridRange.cs` (unit tests)
- `tests/FreeX.Core.IO.Tests/XlsxPivotSingleCellLocationLoadTests.cs` (new)

## Out of scope / notes

- Did not touch dynamic-array calc, chart writer, or pageSetup code.
- `ParseOptionalRange` (pivot **source** ref, same file) already swallows parse
  failures and returns `default`, so a single-cell source ref would silently
  produce an empty range. Not changed here (no observed failure, and the
  contextures source refs are full ranges), but a candidate follow-up is to
  route it through `ParseCellOrRange` too for correctness rather than silent
  loss.
- Other `GridRange.Parse` callers (slicers/tables/defined names) were not
  modified — the only single-cell ref in this workbook was the pivot location.
