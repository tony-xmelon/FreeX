# FreeP ChartEx value-color scale parity

## Scope

Native ChartEx series can define a continuous value-color gradient with
`cx:valueColors` (`minColor`, `midColor`, `maxColor`) and optional
`cx:valueColorPositions` stops. FreeP previously retained that XML only inside
the opaque preserved ChartEx payload, so callers could not inspect or edit the
semantic scale without flattening the chart family.

## Implemented

- Added `ChartValueColorScale` and `ChartValueColorPosition` to the shared chart
  model.
- Reader imports theme-aware solid colors and numeric, percentage, and extreme
  stop positions from native ChartEx series.
- Writer updates only those modeled children and preserves the rest of the
  ChartEx family payload and sequence.
- Slide cloning deep-copies the scale and its stop positions.

## Gates

- Focused value-color round-trip: 1/1.
- The change is semantic/package parity only; no raster calibration claim is
  made in this slice.

## Source contract

The Microsoft ChartEx schema defines `valueColors` and `valueColorPositions`
as ordered children of `cx:series`; the implementation follows that order and
keeps unsupported family-specific children untouched.
