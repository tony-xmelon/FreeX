# FreeP Wave 181 bullets/autofit marker fallback

Date: 2026-08-22

## Scope

The bounded fixture is `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`,
slide 1. Its six-paragraph `a:spAutoFit` list explicitly authors
`a:buFont typeface="+mj-lt"`, which resolves to the Office theme's `Aptos Display`
major font. The shared paragraph plan preserved that authored marker font, but
Avalonia's `DrawBulletAvalonia` path bypassed the existing PowerPoint fallback used
for paragraph text and painted the unavailable family directly.

## Correction

Avalonia's existing host-local `SlideCanvas.ResolvePowerPointFontFamily` now maps
both unavailable Office Aptos families (`Aptos` and `Aptos Display`) to `Arial`.
Bullet glyph painting uses that same host resolver as paragraph text; title and
paragraph behavior remain consistent with the host-local policy. WPF remains on its
existing native marker path. This is a renderer fallback correction, not
fixture-specific content or a comparison-threshold change.

## Recalibrated metrics

Fresh 1280x720 current-source captures were written under the ignored worktree
directory `artifacts/wave181-final/` and compared with the committed Office PNGs
under `tools/FreeP.RenderCompare/corpus/pptx-ref/17-bullets-autofit/`.

| Fixture / slide | WPF before | WPF after | Avalonia before | Avalonia after | Pair before | Pair after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `17-bullets-autofit` / 1 | 0.8441% | 0.8441% | 0.8537% | **0.8339%** | 0.8386% | 0.8439% |
| `17-bullets-autofit` / 2 control | 3.0587% | 3.0587% | 3.1232% | 3.1232% | 3.1324% | 3.1324% |

The affected current-source recalibration rows and aggregate values are updated
in `docs/parity/freep-powerpoint-recalibration-2026-08-15.json`. The committed
Office references were not regenerated because the authoritative reference PNGs
did not change. PowerPoint COM was not required for this recalibration; the
committed COM exports remain the comparison authority.

## Verification and residuals

- `TextLayoutPlannerTests` + `BulletsAutofitTests`: 130 passed.
- `SlideCanvasLineSpacingTests`: 15 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: 0 warnings, 0 errors.
- `17-bullets-autofit` slide 2 remains the largest residual: 3.0587% WPF vs Office, 3.1232% Avalonia vs Office, and 3.1324% WPF/Avalonia. Its fixed-size no-autofit body is still dominated by Aptos rasterization and host antialiasing differences; no full Office parity claim is made.
