# Floating Wave1 Core Registration

## Scope

The imported `drawing-objects-complex.docx` floating WordArt `FreeW` is an
exact 30-point `GlowBlue` / `Wave1` signature. Its established WPF overlay
anchor correction already aligned the object vertically, but raw Word pixels
showed the opaque dark core was still 8 DIPs too narrow, 7 DIPs too short, and
inset 4 DIPs horizontally and 6 DIPs vertically.

WPF now expands only this signature's opaque fill child by 8 by 7 DIPs and
places it at `(-4, -6)`. The shared Wave1 geometry, outer glow, and all other
WordArt routes remain unchanged.

## Matched Evidence

Persistent Word baseline:
`C:\Users\ali\AppData\Local\Temp\FreeW-WordBaselineSurfaceRefresh-20260717`

Fresh WPF Release composite at 816 by 1056:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| `drawing-objects-complex` whole page | 6.4490% | 6.3953% | -0.0537 pp |
| Wave1 WordArt | 17.3390% | 15.2439% | -2.0951 pp |
| Tight dark core | 21.4707% | 17.7959% | -3.6748 pp |
| Adjacent chart | 8.8983% | 8.8983% | stable |

The primary `wordart-watermark-stress` control is SHA-256 byte-stable against
the accepted Wave1-phase render. `wordart-picture-watermark-layout` is
byte-stable against its current-main baseline.

## Verification

- Focused floating Wave1 and source-guard tests: 2/2 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.

## Process Note

Measure the opaque core independently from the glow envelope and glyph path.
The earlier vertical overlay correction, this core registration, and the
separate 32-point Wave1 phase correction have different visual owners.
