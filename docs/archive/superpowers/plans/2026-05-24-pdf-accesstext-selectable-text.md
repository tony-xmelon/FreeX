# PDF AccessText Selectable Text

## Goal

Improve selectable PDF text overlay fidelity for WPF `AccessText` content used by labels and access-keyed command surfaces.

## Scope

- Add a regression test for `AccessText` content in exported PDFs.
- Extract `AccessText.Text` into the existing overlay after removing access-key underscores.
- Keep raster rendering unchanged.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host PDF overlay tests.
- Full solution build with shared build servers disabled.
