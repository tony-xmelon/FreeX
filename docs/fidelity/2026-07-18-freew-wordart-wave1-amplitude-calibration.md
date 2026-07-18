# WordArt Wave1 Amplitude Calibration

## Scope

`DrawingObjectVisualPlanner.BuildWordArtPlacementPlan` now uses half of the prior
Wave1 amplitude bound. The previous synthetic sine deformation was materially
stronger than the imported WordArt text path rendered by Microsoft Word. This
keeps the shared planner authoritative so WPF and Avalonia consume the same
measured geometry.

## Matched Evidence

The fixture is `wordart-watermark-stress.docx`, captured against the persistent
816x1056 Word COM PNG. Both renderer captures use the normal print-layout page
surface path from freshly rebuilt Release artifacts.

| Renderer | Whole page | Wave ROI `(250,70)-(760,280)` | Panel `(100,40)-(800,340)` |
| --- | ---: | ---: | ---: |
| WPF before | 7.8113% | 10.5496% | 9.2887% |
| WPF after | 7.7588% | 10.2284% | 9.0733% |
| Avalonia before | 6.2028% | 11.2461% | 9.2901% |
| Avalonia after | 6.1810% | 11.2124% | 9.2009% |

The Avalonia before/after pair was captured from the same rebuilt current-main
artifact with only this planner value changed. The `wordart-picture-watermark-layout`
(ArchUp) and `object-format-position-size-style` controls were SHA-256 stable.

## Guard

Treat the Wave1 bound as a text-path geometry calibration, not a generic
WordArt scale or effect tuning. Future changes require the same Word COM target,
both renderer ROIs and whole-page scores, plus byte-stable non-Wave1 controls.
