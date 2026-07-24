# FreeP Avalonia Rich Table-Cell Editing

## Scope

The Avalonia in-canvas table-cell editor already preserved mixed runs through the shared
`InCanvasRichTextEditBuffer`, but its visual editing surface dropped paragraph list markers.
Applying bullets or numbering therefore changed the model and committed correctly while the
active editor showed only the plain paragraph text.

The shared visual plan now carries marker text, marker formatting, image-bullet payloads, and
paragraph indent metadata separately from editable text. Avalonia renders those markers beside
the rich text surface, so selection offsets and committed text remain unchanged. Auto-numbering
uses the same `SlideCompositor.FormatAutoNum` contract as slide rendering.

## Verification

- `InCanvasRichTextVisualPlannerTests`: 5/5
- Avalonia rich editor and table-cell tests: 19/19
- Presentation rich-text/table planner tests: 74/74
- Avalonia Release test build: 0 warnings, 0 errors

This is a functional editing slice, not a broad raster calibration. The remaining long-tail
editor work includes inherited list-style resolution and richer inline effects inside the live
editing surface.
