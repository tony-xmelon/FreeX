# FreeP WPF imported WordArt shadow fit

Date: 2026-07-18

## Fixture

`tools/FreeP.RenderCompare/corpus/13-wordart.pptx`, slide 1, rendered at
1280x720 against a fresh same-host PowerPoint COM export.

## Change

The imported 40pt `Text Shadow` run has no warp and a 5pt authored shadow.
WPF's fallback typeface raster was wider and taller than PowerPoint's text
while its shared shadow geometry was already calibrated. The WPF renderer now
applies a signature-guarded horizontal/vertical fit to that run's effect
geometry only. ArchUp, Wave, outline, gradient, Avalonia, and generic shadow
runs are untouched.

## Evidence

| Surface | Before | After |
| --- | ---: | ---: |
| WPF whole page | 1.5398% | 1.3614% |
| WPF Text Shadow `(590,55)-(940,160)` | 8.0771% | 3.6021% |
| WPF Gradient `(40,50)-(570,165)` | 4.9317% | 4.9317% |
| WPF Outline `(40,210)-(570,325)` | 7.6724% | 7.6724% |
| WPF ArchUp `(700,215)-(1120,340)` | 2.8043% | 2.8043% |
| WPF Wave `(470,370)-(790,470)` | 1.7534% | 1.7534% |

The exact authored-fill bbox moved from `(610,80)-(925,118)` to
`(611,86)-(910,120)`; PowerPoint is `(611,86)-(909,120)`. The `08-effects`
control is SHA-256 byte-identical, and the complete Avalonia WordArt output is
SHA-256 byte-identical before and after.

## Verification

- `WordArtTests|RendererNeutralDedupPlannerTests`: 48/48.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF/Avalonia renders and PowerPoint COM export completed successfully.
- Candidate and baseline used the same WPF composite provenance.
