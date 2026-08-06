# FreeP Change Font Size Animation Parity

Date: 2026-08-06

## Source evidence

PowerPoint COM created an emphasis animation with `presetClass="emph"`,
`presetID="4"`, and `presetSubtype="2"`. Its child behavior is a numeric
`p:anim` targeting `style.fontSize` with `to="1.5"`, rather than the
`p:animScale` payload used by FreeP's existing Grow/Shrink model. PowerPoint's
official effect enumeration identifies `msoAnimEffectChangeFontSize` as 57;
the OOXML timing payload is the authoritative package evidence:
<https://learn.microsoft.com/en-us/office/vba/api/powerpoint.msoanimeffect>.

## FreeP behavior

The reader maps the exact native `emph/4` token to `AnimationPreset.Grow` so
the existing amount-aware playback planner exposes the authored 150% amount.
The original numeric `p:anim` is retained separately on `ShapeAnimation` and
the writer re-emits it instead of synthesizing `p:animScale`. Clone and
command-planner paths preserve the same native payload.

This is functional parity for import, playback amount, and package
round-trip. It is not a claim that WPF or Avalonia paint a text-only font-size
animation with PowerPoint-identical glyph rasterization; that remains a
separate visual-rendering capability.

## Verification

- `AnimationPresetRoundTripTests`: 39/39.
- The focused contract verifies `emph/4`, subtype `2`, `style.fontSize`,
  150% Grow/Shrink playback, clone preservation, and absence of `p:animScale`.
