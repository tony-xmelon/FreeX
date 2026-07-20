# FidelityRender Floating Shape Effect Footprint

## Scope

Direct floating shapes in the WPF fidelity compositor were painted through a `VisualBrush` with
`Stretch.Fill`. WPF includes the DropShadow effect footprint in that brush, then scales the visual
back into the authored rectangle. The result shrank the opaque shape core relative to Word.

## Change

Direct floating shapes now use `Stretch.None`; images, WordArt, charts, SmartArt, drawing groups,
and all other visual roots retain `Stretch.Fill`.

## Matched Word Evidence

Fresh Release WPF renders against the cached 816x1056 Word baseline:

| Fixture / Region | Before | After |
| --- | ---: | ---: |
| `object-format-position-size-style` whole page | 6.1948% | 6.1631% |
| Object shape ROI `(100,220)-(350,335)` | 15.6806% | 14.7295% |
| `drawing-objects-complex` whole page | 7.1443% | 7.1413% |
| Its direct-shape ROI `(110,180)-(330,300)` | 19.1304% | 19.0333% |
| `wordart-watermark-stress` whole page | 7.7588% | 7.6702% |

For the object-format shape, exact `#FCE4D6` fill changed from WPF bbox `(136,242)-(317,309)` to
`(130,238)-(322,316)`, toward Word `(129,236)-(326,318)`.

## Controls

Fresh `chart-smartart-complex` pages 1-2 and `f2-01-float-wrap` page 1 were pixel-identical to the
current-main WPF controls.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false`
- Focused `VisualEvidenceFidelityRenderSourceTests`
- Fresh Release `--no-build --no-restore --composite` target and control renders.
