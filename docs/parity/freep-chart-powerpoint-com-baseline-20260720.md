# FreeP chart PowerPoint COM baseline - 2026-07-20

## Scope

Fresh Microsoft PowerPoint COM exports were captured at 1280x720 from the
current main artifacts and compared with the current Release WPF and Avalonia
renderers. The captures cover the existing chart baseline-depth, chart-types,
and chart-label corpora.

## Results

| Corpus | Slides | WPF mean | Avalonia mean |
| --- | ---: | ---: | ---: |
| `22-chart-baseline-depth.pptx` | 1 | 2.6046% | 1.0906% |
| `18-chart-types.pptx` | 4 | 0.7585% | 0.3122% |
| `19-chart-labels.pptx` | 3 | 1.2707% | 0.6103% |

The chart-types sequence is the strongest current control: all four pages
remain below 0.76% WPF and 0.32% Avalonia. The remaining chart-label residual
is concentrated in WPF Cartesian label/grid raster and small plot-registration
differences; prior text-formatting, plot-frame, and grid-offset probes were
rejected across the complete three-page sequence. The baseline-depth outlier
is the mixed Surface3D scene: its surface ROI is approximately 5.04% WPF and
4.26% Avalonia, while stock, scatter, and 100%-stacked regions remain bounded
controls.

## Provenance and verification

- PowerPoint COM exports completed: `1/1`, `4/4`, and `3/3` slides.
- Candidate and reference artifacts use the same 1280x720 raster dimensions.
- FreeP `RenderCompare` Release build: 0 warnings, 0 errors.
- Existing reference PNGs under `tools/FreeP.RenderCompare/corpus/pptx-ref`
  remain the comparison source; no renderer source calibration was changed by
  this evidence slice.

## Remaining work

The readiness gap is closed for these three corpora, but exact parity is not:
Surface3D mesh/camera/facet ownership, WPF chart-label rasterization, broader
stock/radar/doughnut/bubble real-deck coverage, and calibrated acceptance
thresholds for additional chart families remain open.
