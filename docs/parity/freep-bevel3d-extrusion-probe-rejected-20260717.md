# FreeP bevel/3-D extrusion probe rejection - 2026-07-17

## Fixture

`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`, slide 1, matched
1280x720 PowerPoint COM and WPF composite captures.

## Probes

Two renderer-only candidates were tested and reverted:

- Increasing the visible bevel surface fraction from `0.40` to `0.65`
  regressed the whole page `1.3231% -> 1.3794%`; Relaxed Inset moved
  `3.2137% -> 3.5880%`.
- Drawing a translated shaded copy for authored `ExtrusionDepthDip` regressed
  the whole page `1.3231% -> 1.7462%`; Relaxed Inset moved
  `3.2137% -> 4.1580%`, Angle + Extrusion `1.4175% -> 3.2759%`, and Contour
  + Depth `2.3108% -> 4.7606%`.

The contour-only region was byte-stable for the bevel-width probe, and the
non-bevel regions were unchanged. Both candidates were rejected because the
PowerPoint extrusion is not represented by a simple translated shaded copy;
future work needs shape-aware projected side faces and material lighting.

## Verification

- Focused bevel/model contracts: 40/40.
- Focused WPF host compile/source contracts: 34/34.
- RenderCompare Release build: 0 warnings, 0 errors.
- Product source was reverted cleanly after the negative probes.
