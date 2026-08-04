# FreeW Avalonia Wave 149 parity: page vertical alignment

Date: 2026-08-04

## Gap

The WPF host now maps Word section `w:vAlign` values to the page body. Avalonia's custom
`DocumentView` already carried the setting through the model and shared planner, but Print Layout
always left body content at the top of each page. Center and bottom aligned `.docx` pages therefore
rendered with visibly different body placement.

## Fix

After the Avalonia body layout pass, Print Layout measures the used body height on each rendered page
and resolves the free-space offset through `PageVerticalAlignmentPlanner`. The offset is applied to
glyphs, tables, paragraph decorations, inline and floating drawing objects, hit-test rectangles,
caret stops, and related wrap/selection geometry together. Header/footer and note bands remain fixed
to their page regions. Top remains unchanged; Justified remains top-aligned because paragraph-spacing
distribution is a separate behavior.

## Regression coverage

`PageVerticalAlignmentTests` verifies that center and bottom alignment move the first body glyph by the
planner's computed per-page offset, and that Web Layout remains continuous/top-anchored.

## Boundary

This is a bounded layout parity fix for the current Avalonia document surface. It uses the document's
current page geometry/alignment for all rendered pages; expanding this to WPF's full per-section page
metrics remains separate. It does not claim Word's Justified paragraph-spacing distribution.

## Verification

- `dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore` - passed, 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~PageVerticalAlignmentTests"` - passed, 2/2.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PageVerticalAlignmentPlannerTests"` - passed, 5/5.
