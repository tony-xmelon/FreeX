# FreeP full-page print markup parity

## Scope

Full-page slide printing now consumes `IncludeCommentsAndInkMarkup` end to end. The shared print package selects a markup-aware raster callback only for that option; ordinary slide exports keep the existing renderer path.

Both WPF and Avalonia expose the same print-only canvas mode. Comment callouts use shared slide-space geometry derived from the comment EMU anchor, while existing shared compositor ink strokes remain in the raster output. Notes-page and handout routes remain unchanged.

## Verification

- `PresentationExportPlannerTests`: 80/80.
- New full-page callback routing and bounded callout geometry contracts: 2/2.
- `WpfPresentationPrintServiceTests`: 5/5.
- `FreeP.App.Rendering.Avalonia.Tests`: 251/251.
- Release builds for Presentation, WPF host, Avalonia renderer, and Avalonia host: 0 warnings, 0 errors.
