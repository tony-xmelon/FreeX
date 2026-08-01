# FreeW Avalonia PDF run surfaces

## Result

The Avalonia direct-PDF path now exports character highlight and character
shading surfaces from the resolved glyph layout. Surface width and height come
from the exact placed run fragment, surfaces paint before glyphs, and character
shading retains the live renderer's precedence over highlight.

The same run adapter now maps italic and bold-italic text to the corresponding
portable PDF font faces instead of flattening italic text to regular or bold.
Run grouping includes background semantics so adjacent differently decorated
runs cannot be merged into one export surface.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- `DocumentViewPdfExportTests|RunDecorationVisualPlannerTests`: 29/29 passed.
- The focused contract verifies highlight, shading-over-highlight precedence,
  positive resolved geometry, background-before-text ordering, italic face, and
  portable PDF serialization.

## Remaining scope

Underline, strikethrough, and selective character-border strokes remain
separate run-level PDF owners.
