# FreeP Wave190 Avalonia SmartArt text-origin parity

Date: 2026-08-23
Base: `2aef931ca0` (`origin/main`)
Corpus: `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide 09, 1280x720
Office authority: `tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list/slide-09.png`

## Accepted correction

Avalonia now applies a measured `-4.0` DIP paint-origin correction to text only
when the compositor's `UseImportedIncreasingCircleTextRaster` flag is true.
That flag is emitted only for the authoritative imported cache topology: live
layout unsupported, `/IncreasingCircleProcess` identity, exactly 12 cached
shapes, 3 ellipses, 3 chords, 6 rectangles, and exactly 4 text-bearing
rectangles. The correction does not inspect visible labels or file names.

The existing `0.930` Aptos-to-Arial calibration is unchanged. WPF is unchanged.
Measurement and font raster policy remain route-scoped; the new value adjusts
only the Avalonia paint origin for this imported text route.

## Target evidence

The before render is the current source at the start of this slice. The after
render is the same source with the correction above. Both use the committed
PowerPoint reference PNG.

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 09 WPF vs Office | 0.9662% | 0.9662% | 0.0000 pp |
| Slide 09 Avalonia vs Office | 1.5440% | 0.8675% | -0.6765 pp |
| Slide 09 WPF vs Avalonia | 1.3657% | 0.8540% | -0.5117 pp |

The semantic SmartArt diagnostic ROI `(x=60,y=60,w=880,h=180)` improves from
`7.3109%` to `3.3749%` mean channel diff. The ROI is diagnostic evidence for
the imported SmartArt frame, not a separate acceptance threshold.

Pixel inspection showed the four Avalonia text child ROIs starting about 4-5
pixels below Office before the correction. Afterward, their top dark-pixel
origins are within 0-1 pixel of Office. The residual remains native text
antialiasing and small shape/text raster differences; this is not a pixel
identity claim.

## Controls

Neighboring slides in deck 15 are unchanged byte-for-byte in Avalonia:

| Slide | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | ---: | ---: | ---: |
| 08 | 1.1608% | 1.1313% | 0.4828% |
| 10 | 1.7356% | 1.5956% | 1.6302% |

Fresh after-render control measurements remain:

| Corpus | Slides | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | --- | --- | --- | --- |
| `06-charts` | 01-04 | 0.9846%, 1.2449%, 0.6149%, 1.2552% | 0.9375%, 1.1365%, 0.5839%, 1.1998% | 0.4242%, 0.3599%, 0.2974%, 0.4455% |
| `14-smartart-live` | 01-04 | 1.3451%, 1.5158%, 0.7149%, 1.7017% | 1.3124%, 1.5689%, 0.7043%, 1.7286% | 1.1567%, 1.0093%, 0.2878%, 0.5210% |
| `26-chart-surface3d-default-tall-frame` | 01 | 2.4757% | 2.2723% | 1.0104% |

All ten fresh WPF renders of deck 15 are byte-stable against the before
capture. The ordinary-authored phase-label negative control remains outside
the imported raster route, and non-Aptos controls retain the generic path.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` - 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-build` - 286/286 passed.
- Focused Avalonia raster/live-renderer tests - 15/15 passed.
- Focused SmartArt and corpus presentation tests - 444/444 passed.
- `FreeP.RenderCompare.Tests` SmartArt evidence filter - 7/7 passed.
- Fresh WPF/Avalonia renders and direct `FreeP.RenderCompare --diff` measurements completed for deck 15, deck 06, deck 14, and deck 26.

PowerPoint COM was not available because `PowerPoint.Application` is not
registered on this host. The committed Office PNG is therefore the
authoritative baseline for all reported Office comparisons. This note makes no
claim about a live COM export, the full corpus aggregate, or unmeasured
PowerPoint UI behavior.
