# FreeP Rich Editor Fallback Typography - 2026-07-24

## Scope

This slice closes the remaining fallback typography mismatch between the WPF and Avalonia in-canvas rich editors. WPF is the authority: inherited runs render with Calibri, using a 14pt shape fallback or a 13pt table-cell fallback unless an explicit run size is available.

## Implementation

- `InCanvasRichTextEditorDefaults` owns the shared font family and fallback point-size contract.
- WPF FlowDocument conversion and both WPF editor activation paths consume the shared contract.
- Avalonia keeps the hidden native TextBox for input and IME behavior, but its visible rich-text surface no longer inherits platform TextBox font metrics.
- Avalonia shape and table-cell activation resolve the same first-explicit-run fallback size as WPF.

## Verification

- `FreeP.App.Presentation.Tests`: `InCanvasRichTextVisualPlannerTests` (4 passed).
- `FreeP.App.Rendering.Avalonia.Tests`: `AvaloniaRichTextEditorTests` plus `SlideCanvasAvaloniaTests.InCanvasTextEditor_OpenMixedRuns_ProjectsSharedRichPlanOntoShapeOverlay` (7 passed).
- `FreeP.App.Host.Tests`: `RichTextEditorTests.WpfAuthority_UsesSharedRichEditorFallbackTypography` (1 passed).

## Remaining rich-editor gaps

Avalonia still uses a custom TextLayout surface over a transparent native TextBox rather than a native WPF RichTextBox equivalent. WPF-authoritative visual parity for deeper list layout, IME edge cases, and the full rich editor interaction surface remains separate work.
