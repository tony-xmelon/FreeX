# PDF Inline Selectable Text

## Goal

Improve selectable PDF text overlay fidelity for WPF `TextBlock` content that is authored with inline runs instead of the `Text` property.

## Scope

- Add a regression test for a `TextBlock` containing `Run` inlines.
- Extract simple inline text and line breaks into the existing PDF overlay.
- Keep raster rendering and text positioning behavior unchanged.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host PDF overlay tests.
- Full solution build with shared build servers disabled.
