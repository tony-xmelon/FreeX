# FreeW Backstage Open Parity, Wave 24

The Open pane now uses a dedicated Avalonia Open-row surface matching the WPF authority: the action label is direct button content, the description is a sibling text block, the search field has the WPF-equivalent width and no Avalonia-only placeholder, and only the selected tab's rows are materialized. The shared `BackstagePaneSurfacePlanner` remains the source of row order, labels, descriptions, and callbacks.

Fresh paired evidence was captured through the real WPF and Avalonia route factories:

- Before: `artifacts/freew-backstage-open-wave24-before-wpf-2/` and `artifacts/freew-backstage-open-wave24-before-avalonia-2/`
- After: `artifacts/freew-backstage-open-wave24-after-3/`
- Scenario: `backstage-open.open`

| Metric | Before | After |
| --- | ---: | ---: |
| Changed-pixel ratio | 0.206863 | 0.194649 |
| Mean absolute channel delta | 17.820 | 16.826 |
| Luminance similarity | 0.821268 | 0.826006 |
| Semantic difference | `action-button-order` | none |

The comparator still classifies the pair as `genuine-visual-mismatch` because the remaining cross-toolkit raster delta is above the comparator's visual classification cutoff. Both captures passed content validation at 560x600; the residual is visual raster/layout variance, not missing content or action-order semantics.
