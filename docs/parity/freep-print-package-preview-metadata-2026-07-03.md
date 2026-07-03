# FreeP Print Package Preview Metadata - 2026-07-03

## Scope

This slice adds shared FreeP print/export package metadata used by both WPF and Avalonia plan consumers. It stays in the handout/export/print presentation layer and does not touch WordArt, notes-page preview, presenter, SmartArt, vertical text, FreeW, or FreeX workbook code.

## Parity Behavior

- `PresentationPrintOutputPackagePlan` now exposes a normalized `PageCount`, `LayoutSummary`, and `SlideRangeSummary`.
- Full-page slide, notes-page, and handout print routes all use the same shared metadata calculation.
- Handout page counts respect the normalized PowerPoint-style handout slides-per-page option.
- Empty decks preserve print intent while reporting `0 pages` and the existing disabled reason.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PresentationExportPlannerTests"`
