# Secondary FillGold Material Registration

## Scope

`wordart-watermark-stress.docx` contains the floating FillGold ArchUp
WordArt `Review Copy` at 26pt (`34.67` DIPs). Its Word gradient panel starts
five pixels above WPF's material surface, while its shared ArchUp glyph plan
is already the correct owner for text geometry.

WPF now adds a background material layer only for this exact signature. The
layer uses the existing WordArt gradient fill, extends 6 DIPs vertically, and
starts 5 DIPs above the canvas. It does not alter the shared ArchUp planner,
GlowBlue material path, or other FillGold objects.

## Matched Evidence

Persistent Word baseline:
`C:\Users\ali\AppData\Local\Temp\FreeW-WordBaselineSurfaceRefresh-20260717`

Fresh WPF Release composite at 816x1056:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.5309% | 7.4709% | -0.0600 pp |
| Secondary WordArt | 8.3240% | 5.4813% | -2.8427 pp |
| Tight gradient panel | 10.7842% | 6.7841% | -4.0001 pp |
| Primary GlowBlue WordArt | 19.4152% | 19.4152% | stable |

The measured FillGold panel starts at Word Y=369 versus WPF Y=374 before the
change; the new material layer starts at Y=369. The independent
`drawing-objects-complex` and `wordart-picture-watermark-layout` controls are
SHA-256 byte-identical.

## Verification

- Focused WPF WordArt/floating/effect tests: 22/22 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh target and controls used the matching persistent Word PNG corpus and
  Release renderer artifact.

## Process Note

For transformed WordArt, separate a material-panel registration error from
glyph-path geometry. Correct the panel on an exact source signature and keep
the shared placement model authoritative until a glyph-specific ROI proves a
different owner.
