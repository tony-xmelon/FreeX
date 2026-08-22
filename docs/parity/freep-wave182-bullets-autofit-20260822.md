# FreeP Wave 182: bullets/autofit raster correction

## Scope

This slice targets `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, slide 2, the largest current Office-reference residual for the FreeP renderer. The PowerPoint body is eight 18 pt Aptos paragraphs with `a:noAutofit`, no authored line override, and no bullets. Its paragraph cadence and fixed-size geometry already match the committed Office reference closely enough that shared layout and bullet-origin changes were not justified.

## Diagnosis

Avalonia resolves the unavailable Aptos body through the existing Arial fallback and 0.95 scale. The residual is primarily host rasterization: the default Avalonia output contains RGB subpixel fringe colors in the body glyphs, while the committed Office PNG and the WPF output are grayscale-antialiased. A body-region probe measured 41,141 Avalonia ink pixels with colored fringe values versus 37,585 Office ink pixels dominated by grayscale values; WPF was also grayscale. The correction therefore belongs in the Avalonia fallback measurement and paint policy, not in shared paragraph geometry.

## Implementation

`SlideCanvas` now defines a semantic optical-size policy for the 18 pt fixed-size Aptos body fallback: `TextAutoFitKind.None`, single-column flow, no bullet-rendering route, and every run resolved from Aptos. Eligible paragraphs use a 0.945 Arial fallback scale for both measurement and paint, plus scoped `TextRenderingMode.Antialias`, `TextHintingMode.None`, and `BaselinePixelAlignment.Unaligned`. Paragraph count, weight, and italic style are not part of the policy. Mixed-font, bullet, autofit, multi-column, non-18 pt, and Aptos Display text keep their existing paths; this leaves slide 1 unchanged.

## Evidence

All 27 corpus decks and 53 tracked slides were rerendered at 1280x720 during the investigation. Eight additional policy-eligible slides changed by at most 0.0001% against their prior Avalonia pixels and did not move their Office or renderer-pair metrics at four-decimal precision. Exact target comparisons use the committed Office PNGs:

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF vs Office, slide 1 | 0.8441% | 0.8441% | 0.0000 pp |
| Avalonia vs Office, slide 1 | 0.8339% | 0.8339% | 0.0000 pp |
| WPF vs Avalonia, slide 1 | 0.8439% | 0.8439% | 0.0000 pp |
| WPF vs Office, slide 2 | 3.0587% | 3.0587% | 0.0000 pp |
| Avalonia vs Office, slide 2 | 3.1232% | 3.0055% | -0.1177 pp |
| WPF vs Avalonia, slide 2 | 3.1324% | 3.0952% | -0.0372 pp |

The Avalonia-to-Office target improves by 3.77% relative and the WPF/Avalonia target improves by 1.19% relative. WPF is unchanged, and slide 1 is unchanged. A raster-only intermediate was rejected even though it reached 2.9976% against Office because it regressed the pair metric to 3.1808%; coupling the fallback scale with the raster policy removes that tradeoff. The recalibration JSON updates the target Avalonia and pair rows plus the derived corpus summary values; unaffected rows retain their prior committed current-source measurements.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter FullyQualifiedName~SlideCanvasAptosRasterPolicyTests`: passed, 1/1.
- WPF and Avalonia render commands completed for all 53 tracked slides.
- Target slide 1/2 Office and renderer-pair diffs were rerun directly after the semantic policy replaced the rejected fixture-signature guard.

## Remaining limitation

The residual remains native glyph-rasterizer variance: Avalonia is now closer to both WPF and Office, but neither comparison is pixel-identical. Thresholds, authority references, the cross-app dashboard, and the Wave 182 integration document were not changed.
