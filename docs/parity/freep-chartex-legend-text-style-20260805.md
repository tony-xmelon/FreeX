# FreeP ChartEx Legend Text Style - 2026-08-05

FreeP now reads native ChartEx `cx:legend/cx:txPr` into the existing
`ChartShape.LegendTextStyle` model and writes an edited style back as a valid
ChartEx `cx:txPr`. The shared text-style builder is namespace-aware, so classic
`c:txPr` output is unchanged while ChartEx uses its required `cx:txPr` owner.

The update preserves the existing legend `pos`, `overlay`, and unrelated
attributes such as `align`. Fresh ChartEx generation can now emit a styled
legend through the same model path.

Verification:

- Focused WPF package test: `1/1`.
- WPF `ChartTests`: `121/121`.
- Presentation ChartEx filter: `5/5`.
- WPF Host Release build: `0 warnings, 0 errors`.
- Avalonia Release build: `0 warnings, 0 errors`.

This is a package/model function slice. It does not claim new ChartEx legend
raster calibration or unsupported legend shape-property authoring.
