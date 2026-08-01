# FreeW Avalonia PDF internal bookmark links

Date: 2026-08-01

## Gap

Avalonia direct PDF export styled internal Word hyperlinks but omitted their clickable regions. The
shared draw-op PDF model represented external URLs only, so an exported link to a bookmark on another
page could not navigate inside the PDF.

## Slice

- Extend shared PDF pages with named destinations in top-left, y-down page coordinates.
- Allow a link overlay to target either an external URI or a named destination.
- Emit Skia named-destination and link-destination annotations.
- Resolve portable-PDF internal links to direct cross-page `/Dest ... /XYZ` arrays while retaining
  clipped link geometry and ScreenTip content.
- Derive FreeW destinations from the actual paginated glyph layout. Imported exact bookmark-start
  boundaries use their retained run index; newly authored whole-paragraph bookmarks target the first
  laid-out paragraph position.
- Preserve external URI behavior and ignore unresolved destination names rather than creating broken
  portable annotations.

## Evidence

The FreeW fixture exports two external links and an internal link on the first physical page, then
forces the imported bookmark target onto a later page. Its bookmark starts before the second run in
the target paragraph. The named destination must share the bold target run's X coordinate, proving
that the exact retained boundary, pagination, and PDF navigation owner agree.

Both shared writers also have backend-level two-page contracts. Skia emits a named destination and
link annotation; the portable writer emits a direct page-object destination with the expected XYZ
coordinates and no URI action.

## Verification

- Shared internal-destination contracts: 2/2.
- Complete `Free.Shared.Pdf.Tests`: 101/101.
- Focused FreeW adapter contract: 1/1.
- Complete `DocumentViewPdfExportTests`: 35/35.
- `Free.Shared.Pdf.Wpf` Release build: 0 warnings, 0 errors.

## Residuals

- This slice changes the shared draw-op model used by Avalonia. WPF raster export retains its existing
  host hook for application-specific internal destinations.
- The portable writer resolves links directly to page objects; it does not expose a public PDF name
  tree for third-party references.
- Visual hyperlink styling is unchanged and remains governed by the existing run-format path.
