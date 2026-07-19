# WPF DrawingML shadow direction

## Scope

The floating text box in `drawing-objects-complex.docx` carries an authored
DrawingML outer shadow. The serialized payload is `blurRad=50800`,
`dist=38100`, `dir=2700000` (45 degrees), and alpha `35000`.

## Change

The measured DrawingML signature uses a coordinate system whose vertical axis
is opposite to WPF's `DropShadowEffect`. The WPF floating-shape renderer now
converts that exact signature with `(360 - direction) % 360` before assigning
the effect. Its guard is black `35%` shadow alpha, `5.33` DIP blur, `4` DIP
distance, and `45` degrees; the shared presentation plan and WordArt-specific
effect path are unchanged.

## Cached Word evidence

The candidate and control were rebuilt from the same branch and rendered from
the same source `.docx` against the persistent 816x1056 Word COM PNG cache.
The external Word wrapper remained in control of COM, so no competing export
was issued.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 7.7540% | 7.7439% |
| Shadowed shape ROI `(100,175)-(340,295)` | 18.6404% | 18.3381% |
| Adjacent chart ROI `(360,325)-(670,535)` | 11.8714% | 11.8714% |

The related `wordart-watermark-stress.docx` backing shape carries a distinct
`28%` alpha signature. A broad conversion regressed its backing ROI from
`15.2145%` to `15.6992%`; the constrained candidate restored the full PNG
byte-for-byte (`70AC104E...301A9`).

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed with 0 warnings and 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~FloatingOverlay_RendersShapeFromSharedPlanWithActualGeometryFillOutlineAndEffect" --logger "trx;LogFileName=floating-shadow-direction.trx"`
  passed 1/1.

## Process note

Read the actual serialized effect payload before tuning a host effect. A
visually plausible removal can score better than a mismapped authored shadow,
but preserving the source effect with the correct host coordinate conversion is
the valid parity fix. Require a same-main control, target ROI, whole-page gain,
and an unchanged adjacent region. Do not generalize a host angle conversion
until every authored shadow signature has matching evidence.
