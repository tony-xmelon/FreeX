# FreeP ChartEx Series Data Labels - 2026-08-05

FreeP now reads the native ChartEx `cx:series/cx:dataLabels` contract into the
existing `ChartDataLabels` model. Series-level value, category, and series-name
visibility, position, number format, separator, text properties, sparse point
overrides, and `dataLabelHidden` entries survive package read and write.

The writer changes only those modeled nodes when a series has an edited label
model. Other ChartEx children, including family-specific layout and extension
payloads, remain preserved. Because the shared chart renderer already consumes
`ChartSeries.DataLabels` and point-level label styles, the imported labels also
remain available to both desktop hosts without a ChartEx-specific renderer fork.

Verification:

- `FreeP.App.Host.Tests` ChartTests: 116/116.
- `FreeP.App.Presentation.Tests` ChartEx filter: 5/5.
- WPF Host Release build: 0 warnings, 0 errors.
- Avalonia Release build: 0 warnings, 0 errors.

This is a bounded ChartEx function/package slice. It does not claim unsupported
ChartEx family-specific label effects or full Office label raster equivalence.
