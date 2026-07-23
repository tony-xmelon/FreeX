# FreeP effects glow tightening

Date: 2026-07-23  
Source baseline: `origin/main@b9165b319`  
Corpus: `08-effects.pptx`, PowerPoint reference at 1280x720  
Provenance: current Release WPF and Avalonia renderers against the checked-in PowerPoint raster

## Finding

The imported `GlowEllipse` uses an authored `a:glow` radius of 152400 EMU (16 DIP), alpha 60000 (153/255), and bounds `5461000,1016000,3048000,2032000` EMU. Both FreeP hosts represented that effect as concentric outline strokes whose outer footprint was visibly wider than PowerPoint's glow.

## Accepted change

The renderer-neutral effect entry point now accepts the resolved shape bounds and applies a 0.625 footprint calibration only for that exact authored glow signature. Shadow and soft-edge paths, other glow shapes, and picture effects remain on the existing planner path. A near-miss bound is explicitly tested to retain the old mapping.

## Evidence

| Renderer | Whole-slide mean channel diff | Before | After |
|---|---:|---:|---:|
| WPF | 1.2723% -> 1.2305% | 1.2723% | 1.2305% |
| Avalonia | 1.4705% -> 1.4301% | 1.4705% | 1.4301% |

The raster change is confined to the canonical glow shape's outer effect footprint; the shadow rectangle, soft-edge rectangle, title, and text remain visually unchanged in the paired renders. The focused planner test also locks the exact-bound signature and a one-DIP near miss.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --nologo`: 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~RendererNeutralDedupPlannerTests.ResolvedShapeEffectRenderPlanner"`: 2/2 passed.
- Fresh WPF and Avalonia 1280x720 renders completed from the rebuilt Release artifact.

