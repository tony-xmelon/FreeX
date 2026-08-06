# FreeP Change Fill Color Animation Parity

Date: 2026-08-06

## Source evidence

PowerPoint COM created Change Fill Color as an emphasis animation with
`presetClass="emph"`, `presetID="1"`, and `presetSubtype="2"`. This is a
different use of `emph/1` from the ordinary Bold effect. Its native behavior
group contains `p:animClr` targeting `fillcolor`, followed by setters for
`fill.type="solid"` and `fill.on="true"`.

## FreeP behavior

The reader recognizes the `fillcolor` target specifically, maps the effect to
the existing renderer-neutral Change Color playback contract, and retains the
original `emph/1` identity. The full native behavior group, including both
setter operations, is preserved on `ShapeAnimation`, cloned through editing
command paths, and re-emitted by the writer. Ordinary Bold `emph/1` remains on
its existing path because it has no `fillcolor` behavior payload.

This closes the import, playback classification, and package round-trip gap.
It does not claim that the current WPF/Avalonia animation overlay paints a
shape fill-only transition with PowerPoint-identical rasterization; that
target-specific compositor behavior remains a separate host-depth item.

## Verification

- `AnimationPresetRoundTripTests`: 40/40.
- The focused contract verifies the fill target, both native setters, raw
  preset identity, clone preservation, and Change Color playback classification.
