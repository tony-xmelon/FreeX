# GlowGold Foreground Material Registration

## Scope

WPF drawing WordArt used its generic high-contrast foreground for `GlowGold`, turning
the authored gold material white on the dark source panel. The shared drawing plan
already retains the `GlowGold` style, so the host now uses the measured Word material
foreground `#D8BA66` for that style while retaining the existing fill and glow plan.

## Matched Word Gate

Reference: cached Word COM PNGs at 816x1056 from the 2026-07-17 baseline corpus.
Candidate: fresh Release `FreeW.FidelityRender` composite after rebuilding the actual
consumer.

| Fixture | Measure | Before | After |
| --- | --- | ---: | ---: |
| `drawing-objects-complex` | whole page | 6.3953% | 6.3885% |
| `drawing-objects-complex` | grouped `Group` WordArt ROI `(590,630)-(690,670)` | 13.5725% | 12.4246% |
| `object-format-position-size-style` | whole page | 6.0733% | 6.0522% |
| `object-format-position-size-style` | `FORMAT` WordArt ROI `(485,375)-(625,430)` | 15.6834% | 13.3285% |

The target `Group` rectangle was already registered within one pixel. Raw material
counts isolated the remaining owner: Word contained 110 exact `#D8BA66` pixels in its
panel while the former WPF route used the generic white foreground.

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~WordArtPlacementSourceGuardTests`
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release`

## Rule

For WordArt, preserve the authored style material separately from panel fill and glow.
Use the shared style metadata to select a material foreground, then require both the
target and an independent same-style fixture to improve before accepting the host path.
