# Avalonia Parity Wave 154 Integration

Date: 2026-08-04

## Scope

Wave 154 reduces FreeW dialog visual differences against the app-owned WPF authority for four
independent dialog families: Table Properties, Options, Page Setup, and Legal Notices. The
production changes remain route-local and retain the existing shared planners, command behavior,
validation, keyboard semantics, and automation identifiers.

## Integrated results

| Dialog family | States | Before average changed pixels | After average changed pixels | Focused verification |
| --- | ---: | ---: | ---: | --- |
| Table Properties | 7 | 24.6568% | 8.8694% | Avalonia 4/4; WPF 3/3 |
| Options | 6 | 7.1025% | 6.1651% | Avalonia 10/10; WPF 6/6 |
| Page Setup | 6 | 8.7298% | 8.5545% | Avalonia 6/6 |
| Legal Notices | 6 | 14.7945% | 14.2593% | Avalonia 13/13 |

All 25 WPF and 25 Avalonia route captures passed their content gates at matching logical sizes
and 96 DPI. The family notes contain the per-state changed-pixel and mean-channel measurements.
The remaining rows are retained as genuine visual mismatches; thresholds and classifications were
not weakened.

Table Properties needs a provenance qualification. Its fresh before capture from the worker's
source revision measured 24.6568%, while the previously tracked aggregate already contained values
close to the 8.8694% result even though the corresponding production structure was not committed in
that source revision. The integrated production code now matches the tracked structure and the WPF
tab ownership. Both observations are preserved instead of treating the stale aggregate as a clean
before baseline.

## Combined verification

- `FreeW.App.Avalonia.Tests`: 33 passed, 0 failed across the four integrated dialog families.
- `FreeW.App.Host.Tests`: 13 passed, 0 failed across Options, Page Setup, and Table Properties.
- Every worker branch produced fresh same-size WPF and Avalonia captures for its assigned routes.
- Generated capture and comparison bundles remain disposable artifacts and were not committed.

## Residuals

- Table Properties Cell remains above the visual threshold because disabled-control painting and
  fixed-height clipping differ between the native stacks.
- Options and Page Setup retain native control-template and text-rasterization differences.
- Legal Notices retains text wrapping and rasterization differences, most visibly on long pages.
- These are visual residuals only; the focused structural and behavioral contracts pass.
