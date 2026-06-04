# PDF TextBox Selectable Text

## Goal

Improve selectable PDF text overlay fidelity for WPF `TextBox` content in fixed documents.

## Scope

- Add a regression test for `TextBox` content in exported PDFs.
- Extract non-empty `TextBox.Text` into the existing overlay.
- Keep raster rendering unchanged.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host PDF overlay tests.
- Full solution build with shared build servers disabled.
