# FreeP Wave184 SmartArt Evidence

Source revision: `2ac7e8e13a`

Date: 2026-08-23
Corpus: current-source 53-slide PowerPoint recalibration, 1280x720
Fixture: `15-smartart-grouped-list.pptx`, slides 06 and 08

## Correction

The shared cached-SmartArt compositor now applies the authored neutral background role to native `lProcess2` group containers and `matrix2` axis caches. The shared DrawingML preset map and geometry builder now preserve `quadArrow`, so WPF and Avalonia render the same four-way matrix axis without renderer-local SmartArt layout logic. Cached fallback child/cell text frames remain on their existing path.

## Metrics

| Slide | Measurement | Before | After |
| --- | --- | ---: | ---: |
| 06 | WPF vs Office | 4.2659% | 1.5481% |
| 06 | Avalonia vs Office | 4.2721% | 1.5581% |
| 06 | WPF vs Avalonia | 0.8137% | 0.8054% |
| 08 | WPF vs Office | 3.2298% | 1.1608% |
| 08 | Avalonia vs Office | 3.1952% | 1.1313% |
| 08 | WPF vs Avalonia | 0.4899% | 0.4828% |

The updated recalibration detail rows are in `docs/parity/freep-powerpoint-recalibration-2026-08-15.json`. Its full-corpus aggregate starts from Wave183's exact 53-slide refresh and applies only the six exact affected-slide deltas: WPF `1.0593%` average / `3.0587%` max, Avalonia `1.0360%` / `3.0055%`, and pair `0.6283%` / `3.0952%`. The prior stale slide-06 detail value `4.2703%` is replaced by the current after value `1.5481%`; the fresh current-source before value is `4.2659%` as reported above.

## Verification

- `FreeP.RenderCompare.Tests`: native cached-role test `1/1` passed.
- `FreeP.App.Presentation.Tests` filtered to `SmartArtLayoutTests`: `216/216` passed.
- `FreeX.Core.Model.Tests` filtered to `DrawingShapeSharedDrawingTests`: `60/60` passed.
- Unaffected slides 01-05, 07, and 09-10 were byte-identical before and after in both renderers.

PowerPoint COM was unavailable on this machine, so the committed Office PNG references were used as ground truth. A broader cached `txXfrm` text-frame correction was rejected: it improved Office similarity but raised slide-06 WPF/Avalonia pair diff to `1.4279%`; the shipped bounded correction preserves pair parity. Remaining residuals are primarily host text rasterization and unsupported SmartArt/chart families outside this slice.
