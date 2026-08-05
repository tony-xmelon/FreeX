# FreeP ChartEx title text style parity

## Scope

ChartEx title text properties now round-trip through the existing
`ChartShape.TitleStyle` model. The reader consumes `cx:title/cx:txPr`, while
the writer updates the preserved title payload or emits a new `cx:title` for
newly authored ChartEx charts. Existing title attributes and rich text are
left intact when the title text is edited.

The implementation uses the ChartEx `txPr` owner defined by the Office
DrawingML ChartEx schema, rather than treating the title as a classic chart
`c:txPr` payload. This keeps title font, size, emphasis, color, and typeface
semantics available to both host renderers without changing chart layout.

## Verification

- `Edit_NativeChartExTitleTextStyle_RoundTripsWithoutDroppingTitleAttributes`: 1/1
- WPF `ChartTests`: 122/122
- Presentation ChartEx contracts: 5/5
- WPF Host Release build: 0 warnings/errors
- Avalonia Release build: 0 warnings/errors

Visual raster calibration is intentionally outside this slice; the accepted
contract is package/model preservation and effective writer output.
