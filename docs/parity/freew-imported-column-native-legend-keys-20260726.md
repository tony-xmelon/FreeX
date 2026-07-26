# Imported Column Native Legend Keys

## Scope

The compact legend for the imported style-7 `mono-blue` column chart was structurally
correct but its color keys were one DIP low and one DIP too large in WPF.

## Measured Registration

At the 400x224-DIP chart frame, Word renders 8-DIP legend keys at local Y=199. The
prior FreeW compact path used 9-DIP keys at Y=200. The adjustment applies only to the
imported native style-7 `mono-blue` single-series column signature; the existing default
Quarterly Revenue signature retains its 9-DIP/Y=200 contract.

## Matched WPF Composite Results

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 1.6904% | 1.6847% |
| Column chart ROI | 4.0285% | 3.9808% |
| Legend ROI | 4.9660% | 4.1441% |
| Scatter control ROI | 5.7109% | 5.7109% |
| Page 2 control | 0.3728% | 0.3728% |

The page-2 PNG SHA-256 is byte-identical before and after.

## Verification

- `ChartSmartArtVisualPlannerTests`: 46/46 compile and 46/46 `--no-build`
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
