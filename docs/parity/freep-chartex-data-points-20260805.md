# FreeP ChartEx Data-Point Formatting - 2026-08-05

FreeP now reads native ChartEx `cx:series/cx:dataPt` shape properties into the
existing `ChartPointStyle` model. Solid, gradient, and pattern fills plus
visible point outlines retain their authored color and width; existing point
label, marker, and explosion state remains attached to the same point index.

When a point style is edited, the writer updates only that point's `cx:spPr`
and preserves the surrounding ChartEx family payload, including `cx:extLst`.
Points without a modeled fill or stroke edit remain verbatim. The shared chart
model is already consumed by WPF and Avalonia, so this is a package/function
slice rather than a host-specific rendering fork.

Verification:

- `FreeP.App.Host.Tests` ChartTests: 117/117.
- Focused native data-point round-trip: 1/1.
- `FreeP.App.Presentation.Tests` ChartEx filter: 5/5.
- WPF Host Release build: 0 warnings, 0 errors.
- Avalonia Release build: 0 warnings, 0 errors.

This is a bounded ChartEx function/package slice. It does not claim complete
ChartEx family-specific point effects or full Office raster equivalence.
