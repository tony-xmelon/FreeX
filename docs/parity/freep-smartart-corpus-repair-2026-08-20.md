# FreeP native SmartArt corpus repair — 2026-08-20

## Cause

`15-smartart-grouped-list.pptx` was hand-authored OOXML whose diagram layout
data did not materialize in Microsoft PowerPoint. PowerPoint COM therefore
exported title-only references, while both FreeP renderers displayed their
reconstructed SmartArt. The apparent renderer discrepancy was a fixture and
baseline defect.

## Repair

The fixture generator now creates all ten slides through Microsoft PowerPoint,
closes the saved presentation before applying the hierarchy identity patch, and
uses OPC forward-slash paths when it reopens the package. The tracked deck and
its ten `corpus/pptx-ref/15-smartart-grouped-list` PNGs were regenerated at
1280x720 by PowerPoint COM.

## Recomparison

| Metric | Previous | Repaired |
| --- | ---: | ---: |
| WPF mean / maximum | 16.2875% / 23.9325% | 2.1018% / 4.5210% |
| Avalonia mean / maximum | 12.3482% / 18.0735% | 2.1208% / 4.6503% |
| WPF–Avalonia mean / maximum | 6.0097% / 13.7186% | 0.8940% / 1.6684% |

All ten repaired slides rendered successfully in PowerPoint, WPF, and
Avalonia. The authoritative baseline and consolidated recalibration retain the
other 43 corpus-slide measurements from 2026-08-16; the ten repaired rows are
explicitly refreshed from the 2026-08-20 capture.
