# FreeP RTF Inline-Table Layout Controls

Date: 2026-08-01

## Function slice

External RTF table descriptors now retain `\\trleft` and `\\trgaph` on inline
`TableShape` payloads; the concurrent row-alignment model retains
`\\trql`/`\\trqc`/`\\trqr`. The values survive
the shared rich-clipboard DTO round trip and are consumed by the WPF and
Avalonia inline-table editors. Existing slide-table payloads keep their
previous defaults because the fields are explicitly rich-text scoped.

Conversions follow RTF units: `trleft` twips to points, and `trgaph` half-gap
twips to total cell spacing points.

## Verification

- `ExternalRichTextClipboardTests.RtfInlineTable_PreservesTableIndentAlignmentAndCellGap`: 1/1
- `ExternalRichTextClipboardTests`: 50/50
- `AvaloniaRichTextEditorTests`: 29/29
- `FreeP.App.Rendering.Wpf` Release build: 0 warnings, 0 errors
- `FreeP.App.Rendering.Avalonia` Release build: 0 warnings, 0 errors
- `FreeP.App.Host` Release build: 0 warnings, 0 errors

The physical SmartArt Apply validation was not run in this environment because
the required Docker executable is unavailable; that is an environment gap,
separate from this completed RTF function slice.
