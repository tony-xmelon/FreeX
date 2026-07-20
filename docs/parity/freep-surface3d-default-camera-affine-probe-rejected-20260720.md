# FreeP Surface3D default-camera affine probe rejected

Date: 2026-07-20
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`
Reference: `tools/FreeP.RenderCompare/corpus/pptx-ref/22-chart-baseline-depth/slide-01.png`

## Authority inventory

An OPC scan of all 24 checked-in PowerPoint decks found exactly one chart part
containing either `c:surface3DChart` or `c:surfaceChart`: chart 2 in
`22-chart-baseline-depth.pptx`. Its only PowerPoint reference is the 1280x720
slide PNG with SHA-256
`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`.
There is therefore no independent checked-in mesh/camera raster for fitting a
second default-camera case.

The package does provide these discriminating source facts:

- three ordered series and three ordered categories on category, value, and
  series axes;
- cached values `10,null,18`, `18,22,26`, and `28,24,35`;
- `varyColors=1`, with no explicit `view3D`, chart style, wall/floor,
  `bandFmts`, wireframe, or `dispBlanksAs` element;
- an external workbook relationship to `chartWorkbook2.xlsx`;
- no `B3` cell node in that workbook's `ChartData` sheet, confirming a real
  missing point rather than zero, an empty string, or a stale cache omission.

These facts establish that Office generated the visible mesh with its default
Surface3D camera and blank-point behavior. They do not independently identify
the camera's vertical lift and final raster translation.

## Rejected probe

Temporary local instrumentation swept the imported default camera's normalized
vertical lift and Y registration. The instrumentation read
`FREEP_SURFACE_PROBE_LIFT` and `FREEP_SURFACE_PROBE_OFFSET_Y`; those reads were
removed and never committed. Broad compression candidates such as `(140,-32)`,
`(145,-30)`, and `(150,-28)` worsened WPF whole-slide error to `2.6601%`,
`2.6646%`, and `2.6717%`, respectively, from the accepted `2.5546%`.

The best local pair changed the 360x189 imported default from lift/offset
`(170,-9)` to `(175,-8)`. It produced identical images when expressed as
deterministic planner constants and appeared to improve both renderers:

| Backend / region | Accepted | Candidate | Delta |
| --- | ---: | ---: | ---: |
| WPF whole slide | 2.5546% | 2.5486% | -0.0060 pp |
| Avalonia whole slide | 2.2959% | 2.2909% | -0.0050 pp |
| WPF Surface ROI `(560,90)-(1030,310)` | 4.915178% | 4.861598% | -0.053580 pp |
| Avalonia Surface ROI | 4.885348% | 4.840762% | -0.044586 pp |
| WPF tight mesh `(590,105)-(980,300)` | 6.016537% | 5.943689% | -0.072849 pp |
| Avalonia tight mesh | 6.023926% | 5.963306% | -0.060621 pp |

Stock, scatter, and 100%-stacked control ROIs were pixel-identical in both
hosts. Candidate focused tests passed 216/216, candidate WPF and Avalonia
renders were healthy and nonblank, and visual inspection found no new surface
artifact.

The candidate is nevertheless rejected. A single reference constrains only
the combined affine vertical result; multiple lift/translation pairs move the
same vertices similarly, and the package's absent `view3D` cannot distinguish
those parameters. Landing `(175,-8)` would therefore be another calibrated
constant fit, not a camera model supported by independent authority. Product
code and locked expectations were restored to current `origin/main`.

## Next evidence

Before changing default-camera lift or registration, add a hash-verified
PowerPoint reference with a different Surface3D plot size, value range, or
explicit `view3D`. One additional case can separate normalized lift from fixed
translation. A useful corpus pair would retain the same source matrix at a
different chart height, plus a complete nonblank matrix under explicit
rotation/elevation/perspective metadata. The existing 3x3 fixture-specific
vertex and boundary constants remain visible debt and were not extended here.
