# FreeP RTF Row Borders

The external RTF clipboard parser now captures `trbrdrl`, `trbrdrr`, `trbrdrt`, `trbrdrb`, and `trbrdrv` row borders. Row-level borders are applied to the effective cell edges: left and right go to the first and last cells, top and bottom are applied across the row, and an interior vertical border is applied symmetrically to every adjacent cell pair. Authored cell-level borders remain authoritative when both forms are present.

The contract covers nested RTF table rows and the internal clipboard serialize/deserialize path. The shared table model feeds the existing WPF and Avalonia border renderers, so no host-specific border representation was added.

Verification:

- `ExternalRichTextClipboardTests`: 52/52 no-build, including the new nested-row border round trip.
- `RichTextEditorTests.WpfInlineTableEditor`: 2/2 no-build.
