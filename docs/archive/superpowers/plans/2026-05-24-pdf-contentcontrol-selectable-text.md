# PDF ContentControl Selectable Text

## Goal

Improve selectable PDF text overlay fidelity for WPF `ContentControl` elements such as labels whose content is plain text.

## Scope

- Add a regression test for string `Label.Content` in exported PDFs.
- Extract non-empty string content from `ContentControl` into the existing overlay.
- Preserve existing traversal for `ContentControl.Content` that is a `UIElement`.
- Keep raster rendering unchanged.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host PDF overlay tests.
- Full solution build with shared build servers disabled.
