# FreeW Backstage Open Visual Parity Wave 116

Date: 2026-08-03

## Scope

This slice targets the canonical `backstage-open.open` WPF-authority row. The
WPF builder and shared Open surface metrics remain unchanged.

## Change

The Avalonia Open recent-file action buttons now use a 17-DIP height and
minimum height. Avalonia's default button template was one DIP taller than the
WPF link-button footprint, so the repeated recent-file rows accumulated a
visible vertical drift. The change is limited to Open action rows; callbacks,
search filtering, tabs, scrolling, automation IDs, and focus behavior remain
unchanged.

## Fresh paired evidence

The same fresh WPF authority capture was compared before and after the change
at 560x600 and 96 logical DPI:

| Metric | Fresh pre-edit | Wave 116 final | Change |
| --- | ---: | ---: | ---: |
| Changed pixels | 62,383 | 56,614 | -5,769 |
| Changed-pixel ratio | 18.5663% | 16.8494% | -1.7169 pp |
| Mean absolute channel delta | 16.2118 | 14.2007 | -2.0111 |
| Perceptual hash distance | 11 | 6 | -5 |

The checked-in comparison before this refresh reported `15.3122%` changed
pixels and `12.8845` mean delta. That older row is not used as the direct
before value because the fresh WPF authority capture has different raster
content. The canonical report was refreshed with the fresh pair and continues
to classify the row as `genuine-visual-mismatch`.

## Verification

- Focused `BackstageViewTests`: 39/39 passed.
- WPF harness Release build: succeeded, 0 warnings, 0 errors.
- Avalonia harness Release build: succeeded, 0 warnings, 0 errors.
- Fresh WPF authority capture: 1/1 captured and content-gate valid.
- Fresh Avalonia capture: 1/1 captured and content-gate valid.
- Focused paired comparison: 1/1 captured; expected non-zero mismatch result.
- Canonical comparison report refreshed for `backstage-open` only.

## Residuals

The row remains a genuine cross-toolkit mismatch. Native tab and scrollbar
templates, search/control chrome, and WPF versus Skia text rasterization still
contribute to the residual. No Linux capture or equivalence claim is made.
