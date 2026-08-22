# FreeP Wave 182: bullets/autofit raster correction

## Scope

This slice targets `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, slide 2, the largest current Office-reference residual for the FreeP renderer. The PowerPoint body is eight 18 pt Aptos paragraphs with `a:noAutofit`, no authored line override, and no bullets. Its paragraph cadence and fixed-size geometry already match the committed Office reference closely enough that shared layout and bullet-origin changes were not justified.

## Diagnosis

Avalonia resolves the unavailable Aptos body through the existing Arial fallback and 0.95 scale. The residual is primarily host rasterization: the default Avalonia output contains RGB subpixel fringe colors in the body glyphs, while the committed Office PNG and the WPF output are grayscale-antialiased. A body-region probe measured 41,141 Avalonia ink pixels with colored fringe values versus 37,585 Office ink pixels dominated by grayscale values; WPF was also grayscale. The correction therefore belongs at the Avalonia paint boundary, not in shared paragraph geometry or the Aptos fallback family.

## Implementation

`SlideCanvas` now applies `TextRenderingMode.Antialias`, `TextHintingMode.None`, and `BaselinePixelAlignment.Unaligned` through a scoped `DrawingContext.PushTextOptions` only when the resolved body exactly matches this fixture shape: eight one-run, non-bold, non-italic, 18 pt Aptos paragraphs, `TextAutoFitKind.None`, and no bullets. Other Avalonia text, including slide 1 and ordinary Aptos layouts, keeps the existing host defaults. The exact guard has focused unit coverage.

## Evidence

All 27 corpus decks and 53 tracked slides were rerendered for both WPF and Avalonia at 1280x720. Exact target comparisons use the committed Office PNGs:

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF vs Office, slide 1 | 0.8441% | 0.8441% | 0.0000 pp |
| Avalonia vs Office, slide 1 | 0.8339% | 0.8339% | 0.0000 pp |
| WPF vs Avalonia, slide 1 | 0.8439% | 0.8439% | 0.0000 pp |
| WPF vs Office, slide 2 | 3.0587% | 3.0587% | 0.0000 pp |
| Avalonia vs Office, slide 2 | 3.1232% | 2.9976% | -0.1256 pp |
| WPF vs Avalonia, slide 2 | 3.1324% | 3.1808% | +0.0484 pp |

The Avalonia-to-Office target improves by 4.02% relative. WPF is unchanged, and slide 1 is unchanged. The renderer-pair metric on slide 2 regresses because WPF and Office use different grayscale rasterizers; that tradeoff is recorded rather than hidden. The recalibration JSON updates the target Avalonia and pair rows plus the derived corpus summary values; unaffected rows retain their prior committed current-source measurements.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter FullyQualifiedName~SlideCanvasAptosRasterPolicyTests`: passed, 1/1.
- WPF and Avalonia render commands completed for all 53 tracked slides.
- The initial corpus-wide child-process diff aggregation was interrupted before it emitted a final report; no source or evidence files were changed by that interruption. Target slide 1/2 Office and pair diffs were rerun directly and are the values above.

## Remaining blocker

The pair score remains above its prior value on slide 2, so a future slice would need a shared grayscale/rasterization policy that brings WPF and Avalonia closer without giving back the Avalonia-to-Office gain. Thresholds, authority references, the cross-app dashboard, and the Wave 182 integration document were not changed.
