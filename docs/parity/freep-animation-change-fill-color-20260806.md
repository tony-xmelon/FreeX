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
a distinct renderer-neutral Change Fill Color playback contract, and retains
the original `emph/1` identity. The full native behavior group, including both
setter operations, is preserved on `ShapeAnimation`, cloned through editing
command paths, and re-emitted by the writer. Ordinary Bold `emph/1` remains on
its existing path because it has no `fillcolor` behavior payload.

During slideshow playback, the WPF and Avalonia hosts create a fill-only mask
from the authored solid shape geometry. They animate a separate color layer
through that mask, leaving the shape text and outline in the normal overlay
untouched. The source and destination colors are resolved by the shared
planner, including theme colors such as `accent2`.

This closes the import, playback classification, package round-trip, and
solid-fill host playback gap. Gradient, picture, pattern, and partially
transparent fill fidelity remain separate work because this route intentionally
requires a resolvable solid source fill.

## Verification

- `FreeP.App.Presentation.Tests` focused planner/round-trip filter: 136/136.
- WPF `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- Avalonia `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.
- The focused contract verifies the fill target, both native setters, raw
  preset identity, clone preservation, source/destination color resolution,
  and distinct Change Fill Color playback classification.
