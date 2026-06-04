# PDF Nested Selectable Text

## Goal

Improve selectable PDF text overlay fidelity by extracting `TextBlock` content that is nested inside common WPF containers, not only direct `Panel` descendants.

## Scope

- Add a regression test for selectable text inside a `Border`.
- Traverse `Decorator` and `ContentControl` children in `PdfTextOverlayExtractor`.
- Keep raster rendering unchanged.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host PDF export test.
- Full solution build with shared build servers disabled.
