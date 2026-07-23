# DrawingML Picture Watermark Alpha

`wordart-picture-watermark-layout.docx` stores its generated 120x72 PNG in a
header DrawingML picture with `a:alphaModFix amt="38000"`. WPF compounded the
PNG's partial alpha with the raw 38% opacity, producing a watermark that was
consistently too light against the matched Word raster.

The shared watermark planner now applies Word's measured 40% effective opacity
only for this imported DrawingML picture signature:

- horizontal picture watermark;
- 48% page-width scale;
- authored opacity 38%;
- 120x72 source image; and
- no native VML picture extent.

Both the live WPF brush and `FreeW.FidelityRender` consume the shared plan.

## Matched Word Evidence

Persistent Microsoft Word reference: 816x1056 PNG from
`FreeW-WordBaselineSurfaceRefresh-20260717`. Fresh Release candidate:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 6.2439% | 6.2329% |
| Picture ROI `(250,430)-(580,690)` | 9.9345% | 9.8507% |
| Picture core `(290,480)-(550,650)` | 8.5173% | 8.3856% |
| Left body | 8.9778% | 8.9607% |
| Right body | 8.1029% | 8.0893% |
| Floating WordArt `(365,285)-(630,375)` | 6.8420% | 6.8420% |

The WordArt text-watermark stress and native VML `DRAFT` controls are
byte-identical. A temporary live Word COM alpha-variant export timed out before
opening either package, so the accepted result is gated against the persistent
same-provenance Word baseline rather than a new export.

## Verification

```text
dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~PictureWatermarkLayoutPlanner
  3 passed

dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore
  0 warnings, 0 errors
```
