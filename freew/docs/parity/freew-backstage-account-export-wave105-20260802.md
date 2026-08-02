# FreeW Backstage Account and Export Parity, Wave 105

The FreeW presentation planner now owns Account and generic action-pane visual metrics. Both the WPF and Avalonia hosts consume those metrics, render planner actions in order, and expose each action label as direct button content with its description as a sibling text element. The existing callbacks remain wired through the planner surface.

Bounded fresh paired captures were taken only for the two affected routes at 560x600. Both hosts passed the rendered-content gates. The comparison below was generated from the fresh route manifests with the existing aggregate used only as the untouched baseline for the two-row refresh.

| Scenario | Changed pixels | Mean channel delta | pHash distance | Luminance similarity | Semantic difference | Classification |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| `backstage-account.open` | 2.5366% | 2.7710 | 0 | 0.914628 | none | `pass` |
| `backstage-export.open` | 13.5435% | 11.5055 | 12 | 0.855760 | none | `genuine-visual-mismatch` |

Export retains a visual residual from framework text/control rendering, but its WPF and Avalonia action orders are identical. The temporary fresh manifests and images are under ignored `artifacts/freew-wave105-*`; the two fresh rows were folded into the canonical FreeW comparison and cross-app dashboard.
