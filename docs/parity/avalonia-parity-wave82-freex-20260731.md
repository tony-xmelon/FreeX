# FreeX Avalonia parity wave 82: merged header selection

Date: 2026-07-31
Scope: FreeX only (`src/FreeX.App.Avalonia`, FreeX Avalonia tests)

## Finding

WPF's `MainWindow.Selection.cs` expands every whole-row and whole-column header selection with
`ExpandRangeToFullyContainMerges`. The helper repeatedly absorbs any merged region that the
selection partially overlaps, including newly exposed adjacent merges. This behavior is used by
plain header clicks, Ctrl-click multi-area additions, Shift header extension, and header drag
continuation.

Avalonia's `MainWindow.RowColumnVisibility.cs` had the same header entry points but selected the
raw whole-row or whole-column range. Selecting a header through a vertically or horizontally
spanning merged cell therefore split that merged cell at the selection boundary, unlike WPF.

## Change

Added an Avalonia-local iterative merge expansion helper and applied it to row/column plain and
Ctrl-add selection paths. Shift extension already funnels through these methods for the normal
header gesture; the resulting selected range now fully contains intersecting merged regions.

Focused coverage is in `R99_AvaloniaHeaderMergeSelectionTests`, covering plain row/column headers
and disjoint Ctrl-added row/column bands.

## Verification

Focused verification passed: `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~R99_AvaloniaHeaderMergeSelectionTests"` passed 4/4.

`dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors. The
FreeX Avalonia lane in `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build`
passed 1,863/1,863 tests. The overall default lane reported 27 failures in existing WPF
`FreeX.App.Host.Logic.Tests` print/clipboard evidence tests; the changed Avalonia project itself
remained green.

Repository preflight validated all completed checks but stopped at the unrelated incoming FreeP
whole-window visual-evidence manifest, which was already stale and was intentionally not
regenerated because that area is outside this assigned FreeX slice.
