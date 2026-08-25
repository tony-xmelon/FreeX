# FreeW Avalonia parity Wave197: Page Setup selector fill

Date: 2026-08-25

## Scope

This slice rechecked the six `page-setup` visual states: `initial`,
`populated`, `validation-error`, `tab-margins`, `tab-paper`, and `tab-layout`.
WPF remained the rendering authority. Ink/Draw behavior and map-chart fidelity
remain explicitly out of scope for the active parity effort.

## Diagnosis and implementation

Fresh captures isolated the repeated residual to the compact selector fill. WPF
renders Page Setup selectors with a shallow vertical `#F0F0F0` to `#E5E5E5`
gradient, whereas Avalonia retained the shared flat `#F0F0F0` fill after the
base dialog chrome normalized realized descendants.

`PageSetupDialog` now owns that WPF-authoritative gradient as route-local chrome
and reapplies it after the base normalization pass. This deliberately leaves the
shared Page Layout selector style unchanged for routes whose WPF authority is
flat.

## Evidence

Fresh route-only evidence:

- Baseline WPF: `artifacts/wave197-freew-page-setup-current/wpf/wpf_dialog_capture_manifest.json`
- Baseline Avalonia: `artifacts/wave197-freew-page-setup-current/avalonia/avalonia_dialog_capture_manifest.json`
- Baseline comparison: `artifacts/wave197-freew-page-setup-current/comparison/freew_dialog_visual_comparison.json`
- Corrected Avalonia: `artifacts/wave197-freew-page-setup-gradient2/avalonia/avalonia_dialog_capture_manifest.json`
- Corrected comparison: `artifacts/wave197-freew-page-setup-gradient2/comparison/freew_dialog_visual_comparison.json`

Both hosts captured all 6/6 states with no unsupported captures. Every state
improved; no state regressed.

| Pair | Before changed pixels | After changed pixels | Before mean channel delta | After mean channel delta |
| --- | ---: | ---: | ---: | ---: |
| `page-setup.initial` | 31,681 | 23,931 | 5.3249 | 4.8298 |
| `page-setup.populated` | 31,681 | 23,931 | 5.3249 | 4.8298 |
| `page-setup.validation-error` | 32,039 | 24,289 | 5.4490 | 4.9538 |
| `page-setup.tab-margins` | 31,681 | 23,931 | 5.3249 | 4.8298 |
| `page-setup.tab-paper` | 14,293 | 12,355 | 2.6221 | 2.5005 |
| `page-setup.tab-layout` | 21,987 | 18,132 | 4.2901 | 4.0413 |
| **Total** | **163,362** | **126,569** | **4.7227** | **4.3308** |

The focused capture is route-only and does not claim a refreshed whole-catalog
aggregate. Remaining Page Setup variance is native text, glyph, selection, and
template rasterization rather than a further evidence-supported geometry change.

## Verification

- Avalonia visual-harness build: succeeded, 0 warnings, 0 errors.
- `PageSetupDialogPlannerTests`: 28 passed, 0 failed.
- Avalonia Page Setup visual and WPF-authority contracts: 9 passed, 0 failed.
