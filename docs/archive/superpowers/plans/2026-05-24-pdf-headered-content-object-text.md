# PDF headered content object text overlay

## Goal

Make PDF selectable/searchable text overlays include simple non-UIElement `HeaderedContentControl.Header` values rendered by WPF through `ToString()`.

## Scope

- Add a failing App.Host PDF export test for a numeric `GroupBox.Header`.
- Reuse the simple content-text extraction path for header values while preserving UIElement header traversal.
- Update architecture and command parity documentation.
- Verify the PDF overlay/export tests and solution build before commit.

## Out of scope

- Full control-template visual tree extraction.
- Pixel-perfect overlay placement for arbitrary complex header templates.
- Tagged PDF and full vector PDF rendering.
