# FreeP Chart Negative-Value Series Parity

## Scope

FreeP now preserves the PowerPoint chart-series `c:invertIfNegative` flag through
PPTX import and export. The shared bar and column planners apply the inverted
solid series color only to negative data points; positive points remain on the
authored series color. Rich gradient and pattern fills retain their existing plan
until a dedicated inversion model exists.

## Evidence

- `ChartSeriesPreservesInvertIfNegativeThroughPackageRoundTrip`: explicit true and
  false OOXML states both survive package round-trip.
- `BarAndColumnPrimitivesInvertOnlyNegativeSolidFills`: shared primitives cover
  both vertical columns and horizontal bars without changing positive points.

This is a functional/package parity slice, not a new raster calibration.
