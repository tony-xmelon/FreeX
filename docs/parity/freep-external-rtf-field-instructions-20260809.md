# FreeP external RTF field instructions

Date: 2026-08-09

## Functional gap

The external RTF reader previously reduced a field instruction such as `PAGE \\* MERGEFORMAT` to only its first token, `PAGE`. The visible cached result survived, but clipboard round-trip lost switches that control field formatting or evaluation.

## Change

`FieldRun.Instruction` now retains the complete bounded non-hyperlink RTF instruction. `FieldType` remains the first token used by native PowerPoint field consumers. The in-canvas clipboard payload carries the optional instruction, and the RTF writer emits it again, falling back to `FieldType` for fields authored by FreeP.

Hyperlink fields retain their existing URI validation and dedicated hyperlink model; their instruction is not copied into a generic field run.

## Boundary

The native PPTX `a:fld` format has only a field type and cached text, so the optional instruction is not emitted into PPTX package XML. This slice is for external RTF and in-canvas clipboard fidelity.

## Verification

- `ExternalRichTextClipboardTests.RtfField_PreservesNonHyperlinkTypeCachedResultAndClipboardRoundTrip`
- Presentation clipboard focused suite
- WPF rich-text clipboard focused suite
- Avalonia clipboard focused suite
