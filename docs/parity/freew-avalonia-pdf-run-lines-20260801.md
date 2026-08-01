# FreeW Avalonia PDF run lines

## Result

The Avalonia direct-PDF path now exports underline and strikethrough strokes
from exact placed-run bounds. Their vertical registration and thickness mirror
the live renderer's line-height fractions and font-size calibration, and the
strokes paint after glyph text.

Placed hyperlink runs now receive the live default hyperlink visual style in
PDF: explicit run colors remain authoritative; otherwise the run uses #0563C1
and is underlined. Run grouping includes underline/strike state so adjacent
styles cannot collapse into one exported fragment.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- Focused PDF and glyph-style filter: 30/30 passed.
- The PDF contract verifies underline, strike, hyperlink color/underline,
  measured positive widths, vertical ownership, post-text ordering, and
  portable PDF serialization.

## Remaining scope

Clickable PDF hyperlink annotations and selective character-border strokes are
separate functional/visual owners and are not claimed by this slice.
