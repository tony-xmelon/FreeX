# FreeP native field-run layout metadata

Date: 2026-08-10

## Scope

Native DrawingML field runs can carry character layout metadata in the nested
`a:fld/a:rPr` element. FreeP now preserves `kumimoji`, `smtClean`, `normalizeH`,
`spc`, `kern`, `baseline`, `rtl`, `cap`, `b`, and `i` through the model, package
reader and writer, in-canvas field cloning, and rich clipboard capture/restore.
Explicit false values and omitted attributes remain distinct.

The containing model `Run` receives the same effective metadata as the field
descriptor so WPF/Avalonia consumers do not need a second field-specific layout
path. This is a functional/package fidelity slice; it makes no raster claim.

## Gates

- `MediaFieldsTests.Field_FieldRun_PreservesNativeRunLanguageAndProofingState`
- `InCanvasRichClipboardTests.CaptureAndCodecRoundTrip_PreservesFieldRunLanguageAndProofingState`
- Release builds for `FreeP.App.Host` and `FreeP.App.Presentation`

## Rule

Preserve native nested field-run properties before attempting renderer tuning;
field edits and clipboard round trips must carry the same authored tokens as
normal runs.
