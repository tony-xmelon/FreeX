# Imported Scatter Native Palette

## Scope

`chart-smartart-complex.docx` carries an imported native Office scatter chart with
`c:style=4`, `colorScheme=colorful1`, and `c:scatterStyle=lineMarker`. Word uses a
blue-gray per-point palette for that exact signature; FreeW was using the generic
blue/orange/gray/yellow gallery colors.

## Reference

- Input DOCX SHA-256: `8B4D493C435F680BC4C23BD04473C949BFF79D484F9CCD65A99941D355E324E3`
- Manually saved Word PDF SHA-256: `CA922FF74B8F326458683990C0EEF31BFAFB1C439EC7F4957BE52ACE3F132198`
- Raster target: `816x1056`, regenerated through `FreeW.PdfRasterize` at native page size.

The regenerated target has `0.0000%` changed pixels above the normal delta threshold
against the existing WinRT Word raster cache, so it confirms the baseline provenance.

## Change

The shared chart planner now emits `#234075`, `#2B4E8C`, `#7180AA`, and `#B0B7CB`
only for imported `Scatter + Style 4 + colorful1` charts. Model-authored scatters and
all other imported signatures keep their existing palette route.

## Matched WPF Composite Evidence

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 1.6867% | 1.6847% |
| Column-chart control | 3.8329% | 3.8329% |
| Scatter-chart ROI | 5.4472% | 5.4261% |
| Scatter plot | 4.0095% | 3.9523% |
| Page 2 control | 0.3747% | 0.3747% |

The column chart and page 2 PNGs are byte-stable. The candidate changed 561 pixels,
all in the imported scatter visual owner path.

## Verification

- `ChartSmartArtVisualPlannerTests`: 47/47.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
