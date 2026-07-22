# Primary GlowBlue Core Registration

## Scope

The floating `FreeW CONFIDENTIAL` WordArt in
`wordart-watermark-stress.docx` is an exact GlowBlue/Wave1 signature:

- 32pt font (`42.67` DIPs)
- `GlowBlue` style and `Wave1` warp
- text `FreeW CONFIDENTIAL`

Its existing blue halo matched Word's outer envelope, but WPF's opaque dark
core was inset within that envelope. The renderer now expands only this
signature's opaque fill layer by 8 DIPs horizontally and 7 DIPs vertically,
with a -4/-1 DIP local offset. The shared glyph placement and halo stay
unchanged.

## Matched Evidence

Persistent Word baseline:
`C:\Users\ali\AppData\Local\Temp\FreeW-WordBaselineSurfaceRefresh-20260717`

Fresh WPF Release composite at 816x1056:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.6702% | 7.5309% | -0.1393 pp |
| Primary WordArt | 22.2676% | 19.4152% | -2.8524 pp |
| Tight dark core | 23.2592% | 19.5591% | -3.7001 pp |
| Secondary `Review Copy` WordArt | 10.0475% | 10.0475% | stable |

The direct dark-core box changed from `(327,231)-(793,291)` to
`(323,230)-(797,294)`, toward Word's `(323,230)-(798,297)`. A larger
13-DIP vertical expansion regressed the whole page to 7.5661%, so the
7-DIP calibration is retained.

The independent `drawing-objects-complex` and
`wordart-picture-watermark-layout` controls are SHA-256 byte-identical.

## Verification

- Focused host rendering/source-guard tests: 22/22 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh target and control composites used the matching persistent Word PNG
  corpus and Release renderer artifact.

## Process Note

Measure the opaque material core separately from its glow envelope. The
envelope can already be correct while an inner WPF child is clipped or inset;
do not compensate by scaling Wave1 glyphs or broadening all GlowBlue paths.
