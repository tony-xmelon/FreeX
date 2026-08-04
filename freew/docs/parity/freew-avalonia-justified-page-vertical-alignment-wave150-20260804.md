# FreeW Avalonia Wave 150 parity: justified page vertical alignment

Date: 2026-08-04

## Gap

Wave 149 added Avalonia Print Layout translation for section page `center` and `bottom` vertical
alignment, but `w:vAlign="both"` (`PageVerticalAlignment.Justified`) remained top-anchored. WPF
spreads unused page-body height through the document flow, so a short multi-paragraph page had
different paragraph placement and pointer hit geometry in Avalonia.

## Fix

`PageVerticalAlignmentPlanner` now resolves the free-space gap for each body-block boundary.
Avalonia measures each print page after the existing body pass, distributes its remaining body
height across the emitted flow-block boundaries, and shifts glyphs, paragraph/table decorations,
inline and floating objects, caret stops, wrap zones, and hit rectangles through the existing body
geometry shift path. The first block stays at the top margin; later blocks receive the cumulative
per-boundary gap. Pages with one block have no artificial spacing.

Continuous/Web Layout remains top-anchored. Multi-column justified pages remain on the existing
top-flow path because the current post-layout shift is page-space-Y based and cannot represent
column-order boundaries without inventing layout data.

## Regression coverage

`PageVerticalAlignmentPlannerTests` verifies that only `Justified` alignment distributes free space
and that zero boundaries are a no-op. `PageVerticalAlignmentTests` verifies rendered placement for
three body paragraphs and uses `DocumentView.TestHitTest` at the shifted second glyph to prove the
interaction geometry follows the distribution.

## Boundary

The current FreeW model exposes one `PageSettings` instance for the document, so this remains
document-wide rather than claiming full per-section vertical alignment. Distribution is bounded to
single-column Avalonia Print Layout; multi-column, section-specific metrics, and Word's broader
pagination rules remain separate work.

## Verification

- `dotnet build freew\FreeW.App.Presentation.Tests\FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore` - passed, 0 warnings, 0 errors.
- `dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore` - passed, 0 warnings, 0 errors.
- `dotnet test freew\FreeW.App.Presentation.Tests\FreeW.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~PageVerticalAlignmentPlannerTests"` - passed, 9/9.
- `dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~PageVerticalAlignmentTests"` - passed, 4/4.
