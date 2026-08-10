# FreeP native field-run decorations

## Scope

PowerPoint DrawingML fields (`a:fld`) can carry the same run-level underline and
strike tokens as ordinary text runs. The reader previously retained field identity,
cached text, font, weight, and color but dropped those decoration attributes.

## Change

`FieldRun` now preserves the authored `a:rPr/@u` and `a:rPr/@strike` tokens plus
boolean compatibility values. The package reader and writer retain exact tokens,
while newly authored boolean-only decorations use canonical `sng` and `sngStrike`
tokens. Field decorations are also copied through model clones, in-canvas editing,
rich clipboard payloads, and RTF-created field runs. The containing `Run` receives
the same values on native import so existing rendering/editing consumers see the
decoration without a second field-specific path.

## Evidence

- `MediaFieldsTests` covers package write/read preservation of `wavyHeavy` underline
  and `dblStrike` field tokens alongside field font and color.
- `InCanvasRichClipboardTests` covers field decoration capture, serialization, and
  restore.

This is a functional package/editing parity slice. It does not claim a new visual
calibration for PowerPoint field glyph rasterization.
