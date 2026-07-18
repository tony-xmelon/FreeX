# FreeP WPF imported effects shadow halo

Date: 2026-07-18

## Scope

The imported `08-effects.pptx` rectangle carries an authored DrawingML outer
shadow with `blurRad=76200`, `dist=107763`, `dir=2699994`, `#404040`, and 60%
opacity. FreeP's WPF renderer already placed the primary shadow pass correctly,
but its hand-built peripheral passes accumulated too densely around the shape.

The WPF renderer now halves only the peripheral-pass alpha for that exact
imported signature. The final planner primary pass, shared planner geometry,
Avalonia renderer, glow, soft edge, and other effect signatures are unchanged.

## Matched PowerPoint evidence

Fresh 1280x720 `--avalonia-compare` export with composite/WPF provenance:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF whole page | 1.4827% | 1.3797% |
| WPF shadow ROI `(70,70)-(480,345)` | 3.0882% | 2.2467% |
| WPF glow ROI `(520,80)-(930,340)` | 1.3277% | 1.3277% |
| WPF soft-edge ROI `(930,80)-(1240,340)` | 7.1179% | 7.1179% |
| Avalonia vs PowerPoint whole page | 1.4705% | 1.4705% |

The ROI rows use the same raw RGB mean-channel normalization as the harness.
The whole-page rows are the harness-reported mean-channel percentages.

Current-artifact WPF controls were SHA-256 byte-stable:

- `12-fills.pptx` no-effect control
- `13-wordart.pptx` WordArt/effect control
- `11-bevel3d.pptx` bevel/effect control

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~RendererNeutralDedupPlannerTests`: 19/19.
- Fresh `--avalonia-compare` target export completed with PowerPoint COM 1/1.

