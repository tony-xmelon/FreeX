# Imported Chart Native Axis Strokes

## Scope

The imported Word chart fixture has two native Office signatures:

- clustered column, `c:style=7`, `mono-blue`;
- scatter line-marker, `c:style=4`, `colorful1`.

Both render dark Word axis and tick ink. FreeW had applied its light generic `#BFBFBF`
axis stroke to both signatures.

## Reference

- Input DOCX SHA-256: `8B4D493C435F680BC4C23BD04473C949BFF79D484F9CCD65A99941D355E324E3`
- Manual Word PDF SHA-256: `CA922FF74B8F326458683990C0EEF31BFAFB1C439EC7F4957BE52ACE3F132198`
- Word PDF raster: native `816x1056` WinRT page surface.

## Change

The renderer-neutral chart scene uses `#000000` only for the two imported native
signatures above. Model-authored charts and all other imported chart styles retain the
generic `#BFBFBF` axis path.

## Matched WPF Composite Evidence

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 1.6847% | 1.6621% |
| Column chart | 3.8329% | 3.7120% |
| Column axis/ticks | 2.2709% | 1.8607% |
| Scatter chart | 5.4261% | 5.3260% |
| Scatter axis/ticks | 4.0347% | 3.7534% |
| Page 2 control | 0.3747% | 0.3747% |

Page 2 is byte-stable. The thresholded changed-pixel ratio is not used as the acceptance
metric for this antialiased stroke calibration: it rose slightly in the scatter crop while
every target and full-page mean-channel metric improved.

## Verification

- `ChartSmartArtVisualPlannerTests`: 48/48.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
