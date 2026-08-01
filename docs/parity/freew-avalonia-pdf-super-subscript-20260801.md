# FreeW Avalonia PDF superscript and subscript

## Result

The Avalonia direct-PDF path now exports superscript and subscript with the
same 0.583 glyph scale and line-height-relative top offsets used by live Print
Layout. PDF baseline origins are derived from those adjusted glyph tops and
effective font sizes rather than exporting both styles at the full base size.

Run grouping includes vertical alignment, preventing adjacent baseline,
superscript, and subscript fragments with otherwise identical formatting from
collapsing into one PDF text operation.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- Focused PDF, headless layout, and super/sub command lane: 68/68 passed.
- The PDF contract verifies 12 pt baseline text, 6.996 pt super/sub text,
  distinct origins, superscript above subscript, and portable serialization.

## Remaining scope

Clickable hyperlink annotations and review/proofing overlays remain separate
direct-PDF owners.
