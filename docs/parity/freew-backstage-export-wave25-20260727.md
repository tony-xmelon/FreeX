# FreeW Backstage Export Parity, Wave 25

The `backstage-export.open` slice now uses the shared export pane planner in both hosts and a matching direct-label action row in WPF and Avalonia. Each export action is a real button with its description as sibling text, preserving callbacks, group order, XPS capability gating, and editable file-type rows.

Fresh targeted paired evidence was captured with `FreeW.DialogVisualHarness`:

- Before WPF: `artifacts/freew-backstage-export-wave25-before-wpf/`
- Before Avalonia: `artifacts/freew-backstage-export-wave25-before-avalonia/`
- Final WPF: `artifacts/freew-backstage-export-wave25-final-wpf/`
- Final Avalonia: `artifacts/freew-backstage-export-wave25-final-avalonia/`
- Final comparison: `artifacts/freew-backstage-export-wave25-final-compare/`
- Scenario: `backstage-export.open`

| Metric | Before | Final | Delta |
| --- | ---: | ---: | ---: |
| Changed-pixel ratio | 18.229% | 18.229% | 0.000 pp |
| Mean absolute channel delta | 14.826 | 14.826 | 0.000 |
| Luminance similarity | 0.837705 | 0.837705 | 0.000000 |
| Semantic difference | `action-button-order` | none | resolved |

Both final captures passed the harness content gate at 560x600. The row remains classified as `genuine-visual-mismatch`: the residual is Avalonia/WPF text rasterization and scrollbar chrome, not missing Export content or action-order semantics. The canonical all-dialog report was not regenerated; the one-row comparison is task-local evidence only.
