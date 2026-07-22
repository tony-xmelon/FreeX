# Floating Wave1 WordArt Registration

## Scope

The imported `drawing-objects-complex` fixture contains one floating WordArt
object with the exact signature:

- text: `FreeW`;
- style: `GlowBlue`;
- warp: `Wave1`;
- font size: 30 pt;
- wrapping: `InFront`.

Raw Word PNG bounds placed its black Wave1 surface 12 DIPs above the WPF
overlay. The anchor paragraph itself was correctly measured; only this
renderer-local transformed-text signature was offset.

## Change

`SyncFloatingObjectsCanvas` applies a measured -12 DIP WPF overlay correction
only to that exact WordArt signature. Other Wave1, ArchUp, WordArt styles, and
normal floating drawings keep their existing shared planner geometry.

## Matched Evidence

Fresh WPF composite rendering against the persistent 816x1056 Word PNG:

| Region | Before mean RGB delta | After mean RGB delta |
| --- | ---: | ---: |
| `drawing-objects-complex` whole page | 18.0695 | 17.4711 |
| Wave1 WordArt `(480,190)-(650,320)` | 67.5445 | 44.2145 |
| Tight Wave1 surface `(490,210)-(630,300)` | 95.6703 | 54.7502 |
| Adjacent chart `(360,320)-(670,530)` | 28.6963 | 28.6963 |

The whole-page changed-pixel ratio improved from 15.1549% to 14.8982%; the
Wave1 ROI improved from 47.0362% to 37.0271%.

`f2-01-float-wrap` and `wordart-watermark-stress` were byte-identical to their
pre-change WPF captures. `object-format-position-size-style` was byte-identical
to the accepted floating-reflection baseline.

## Verification

```powershell
dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj `
  --configuration Release `
  --filter FullyQualifiedName~FloatingOverlay_UsesOuterOnlyGlowLayerForImportedFreeW30PointWave1Signature `
  --disable-build-servers `
  --logger "console;verbosity=minimal"
```

Result: 1/1 passed. The consuming `FreeW.FidelityRender` Release build was
clean before the candidate render.
