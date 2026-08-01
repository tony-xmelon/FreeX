# FreeW Skia PDF font-family fidelity

## Scope

FreeW already resolved the effective run font from document defaults, named styles, and direct
formatting before layout. The shared `PdfText` operation did not preserve that family, so the
Unicode Skia PDF backend rendered every run with its platform default font even when the editor and
Word used authored families.

This slice adds an optional font family to the backend-neutral text operation. The Skia writer
caches typefaces by family plus regular/bold/italic/bold-italic face and embeds the selected fonts.
The portable writer retains its documented standard-font fallback. FreeW now supplies resolved
families for body text, floating shape text, SmartArt node text, and WordArt glyphs.

FreeW's PDF run-grouping key also includes font family. Without that boundary, adjacent families
with otherwise identical formatting were incorrectly merged into one text operation.

## Verification

- Shared PDF build: 0 warnings, 0 errors.
- Shared PDF tests: 99/99 passed.
- FreeW Avalonia test build: 0 warnings, 0 errors.
- Focused FreeW font-family adapter contract: 1/1 passed.
- Complete `DocumentViewPdfExportTests`: 34/34 passed.

The shared raster contract renders identical text and geometry with Arial and Courier New and
requires different output. The FreeW adapter contract requires two adjacent authored families to
remain distinct `PdfText` operations with their exact family names.
