# FreeW Wave 182 Font Dialog Slice

Date: 2026-08-22
Scope: FreeW Avalonia Font dialog field and action chrome, compared against fresh WPF authority captures.

## Selection and root cause

The canonical 291-row evidence contained 141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions. The canonical route aggregate ranked `legal-notices` first, but its fresh six-state capture showed that the tracked geometry discrepancy was stale and the bounded product-only experiments did not improve the normalized comparison. `font` was the next highest reproducible product-owned family after the Wave 181 Style family, with three mismatch states and a direct chrome-height cause visible in fresh captures.

Fresh WPF authority showed a 25px font-family text box, 24px size/color combo boxes, and 24px action buttons. Avalonia `FontDialog` was using 18px, 22px, and 20px respectively through its local `DialogChromeStyle`, compressing the dialog vertically.

## Implementation

Updated `freew/FreeW.App.Avalonia/FontDialog.cs` to use the WPF authority heights: `TextBoxHeight = 25`, `ComboBoxHeight = 24`, and `ButtonHeight = 24`. WPF code, authority captures, tolerances, and canonical baselines were not changed.

Updated `freew/FreeW.App.Avalonia.Tests/FontDialogVisualParityTests.cs` so the focused headless assertions cover the authority heights and the materialized text-box/template-border geometry.

## Fresh route evidence

Evidence was captured in the ignored, route-local `artifacts/wave182-freew-font` directory:

- `final/wpf`: fresh WPF authority, 3/3 captured.
- `final/avalonia`: fresh Avalonia route, 3/3 captured/content-gated.
- `final/compare`: normalized-frame JSON, HTML, and heatmaps.

The comparison used the existing inventory and WPF authority manifest. It did not merge or regenerate the tracked canonical comparison.

| State | Changed pixels before | Changed pixels after | Mean channel delta before | Mean channel delta after | pHash before | pHash after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 16.76% | 11.50% | 11.58 | 9.88 | 10 | 7 |
| `font.populated` | 16.83% | 11.60% | 11.65 | 9.98 | 10 | 7 |
| `font.validation-error` | 16.97% | 11.76% | 11.83 | 10.18 | 10 | 7 |
| Average | 16.8532% | 11.6162% | 11.6888 | 10.0132 | 10 | 7 |

The changed-pixel average improved by 5.2370 percentage points, a 31.1% relative reduction. Avalonia painted height moved from 298px to 313px against WPF's 321px authority; the remaining 8px height and 2px width difference, plus native typography and rasterization, keep all three rows honestly classified as `genuine-visual-mismatch`.

## Verification

- WPF harness build: success, 0 warnings, 0 errors.
- Avalonia harness build: success, 0 warnings, 0 errors.
- Focused `FontDialogVisualParityTests`: 3 passed, 0 failed, 0 skipped.
- Final WPF route capture: 3 captured, 0 unsupported.
- Final Avalonia route capture: 3 captured, 0 unsupported.
- Final route-local comparison: 512 inventory rows processed; 3 genuine visual mismatches, 70 invalid-capture-content rows, and 218 product-parity-gap rows because the command intentionally compared only the three `font` captures.

The Wave 182 integration document and cross-app dashboard remain untouched for orchestrator integration.
