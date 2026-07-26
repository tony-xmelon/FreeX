# Imported Column Native Palette

## Scope

The imported `chart-smartart-complex.docx` column chart has native `c:style=7` and
FreeW metadata `colorScheme=mono-blue`. Office treats the native style id as a theme
recipe rather than FreeW's similarly numbered gallery preset.

## Source and Raster Evidence

- Manual Word PDF SHA-256: `CA922FF74B8F326458683990C0EEF31BFAFB1C439EC7F4957BE52ACE3F132198`
- Target raster: 816x1056 px
- Word bar fills: `#4679A7`, `#5591C7`, `#84AEDC`, `#B8CDE8`
- Prior FreeW gallery colors: `#214A82`, `#2E5FAA`, `#4472C4`, `#6C8FD1`

## Accepted Rule

For imported native column charts with `c:style=7` and `colorScheme=mono-blue`, the
shared chart planner emits Word's Office-theme bar palette. Charts authored in the
FreeW model, and every other native chart signature, keep their existing palette path.

## Matched WPF Composite Results

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 1.7940% | 1.7033% |
| Column chart ROI | 4.8998% | 4.1373% |
| Scatter chart ROI | 5.7109% | 5.7109% |
| Page 2 whole | 0.3728% | 0.3728% |

The page-2 PNG SHA-256 is byte-identical before and after. A native style-4 scatter
palette probe regressed its ROI from 5.7109% to 5.7151%, so it was reverted and is
not part of this slice.

## Verification

- `ChartSmartArtVisualPlannerTests`: 45/45 compile and 45/45 `--no-build`
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
