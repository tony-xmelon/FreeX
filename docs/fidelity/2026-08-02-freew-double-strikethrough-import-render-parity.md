# FreeW Word double-strikethrough import and render parity

Date: 2026-08-02

## Scope

FreeW now retains and renders Word's `w:rPr/w:dstrike` run property independently from ordinary
`w:strike`.

- `RunFormatting.DoubleStrikethrough` defaults to `false` while preserving the existing single-strike
  flag independently.
- The DOCX reader accepts all Word on/off lexical forms.
- Run, style, and document-default writers emit enabled state canonically as an empty `w:dstrike`
  after `w:strike` and before `w:noProof` in the `CT_RPr` sequence.
- Reopen, second save, document clone, nested altChunk, and ODT overlays retain the property.
- ODT import/export maps the distinct `style:text-line-through-type="double"` form without changing
  ordinary single strikethrough.

## Rendering ownership

- WPF paints two font-relative strikethrough decorations on body and floating-shape text. The complete
  model snapshot remains authoritative on commit, so the custom decoration objects cannot collapse the
  property into an ordinary strike.
- Avalonia paints two calibrated midline strokes for body, tab spans, and floating-shape text.
- Direct Avalonia PDF export emits two separate `PdfLine` operations for double strike and one for the
  adjacent single-strike control.
- When both source flags are present, both remain serialized, while double strike wins only at paint time.

## Acceptance gates

- Focused compiling and no-build model gates: `3/3`.
- Focused compiling and no-build DOCX/ODT/altChunk gates: `22/22`.
- Focused compiling and no-build WPF render/commit gates: `3/3`.
- Focused compiling and no-build Avalonia PDF gate: `1/1`.
- Adjacent WPF run-roundtrip and floating-object controls: `80/80`.
- Full adjacent Avalonia direct-PDF controls: `68/68`.

No Word COM raster is required for this deterministic property slice. A dedicated double-strike control
in the Font dialog is tracked as a separate authoring surface; this slice covers imported content,
package retention, live rendering, edit/commit retention, and direct PDF output.
