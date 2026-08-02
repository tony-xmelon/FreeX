# FreeW page-border header/footer rendering parity

Date: 2026-08-02

## Scope

Word's document-global `w:bordersDoNotSurroundHeader` and
`w:bordersDoNotSurroundFooter` settings affect page-border geometry only when
`w:pgBorders/@w:offsetFrom="text"`. The settings independently move the top or
bottom border reference from the header/footer text distance to the body margin.
Page-relative borders are unaffected.

The package/model round-trip is recorded separately in
`2026-08-02-freew-page-border-header-footer-settings-parity.md`.

## Implementation

`PageBorderTextFramePlanner` is the shared geometry owner. It selects:

- top reference: header distance, or top margin when the header is excluded;
- bottom reference: footer distance, or bottom margin when the footer is excluded;
- Word's 36-point fallback when an included header/footer distance is absent.

The same frame is consumed by:

- WPF live editor page chrome;
- WPF Print Preview;
- `FreeW.FidelityRender` composite output;
- Avalonia live page rendering;
- Avalonia direct PDF export.

Existing page-relative border geometry and style/layer dispatch remain on their
prior paths.

## Verification

- Shared planner compiling test: 5/5.
- Shared planner no-build rerun: 5/5.
- Avalonia focused direct-PDF geometry: 6/6.
- Avalonia full `DocumentViewPdfExportTests`: 65/65.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- WPF fidelity/live/preview source ownership contracts: 21/21.
- Package/model tests: model 4/4, IO 20/20, adjacent settings 43/43.

The direct-PDF test covers all four independent header/footer combinations and
an `offsetFrom="page"` no-effect control. No fresh Word raster comparison was
needed or claimed for this semantic geometry slice.
