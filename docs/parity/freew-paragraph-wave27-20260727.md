# FreeW Paragraph Dialog Wave 27

Target-only WPF/Avalonia evidence for the Paragraph initial, populated, validation, and Indents and Spacing states. The canonical all-dialog report was not overwritten.

## Validation State Metrics

The canonical row supplied for this slice was `0.1860335622` changed pixels and `18.6459` mean channel delta. A fresh pre-edit pair measured `0.185576` and `18.6959`; the final pair measured `0.175667` and `17.4630`.

| State | Final changed ratio | Final mean delta | Dimensions | Semantic difference |
| --- | ---: | ---: | --- | --- |
| `paragraph.initial` | 0.167262 | 16.5871 | 380x345 | none |
| `paragraph.populated` | 0.167262 | 16.5871 | 380x345 | none |
| `paragraph.validation-error` | 0.175667 | 17.4630 | 380x345 | none |
| `paragraph.tab-indents-and-spacing` | 0.167262 | 16.5871 | 380x345 | none |

The route-local manifests, PNGs, and heatmaps are under `artifacts/freew-paragraph-wave27-final-*` in the task worktree.

## Implementation

- Added optional WPF-authority palette properties to the shared Avalonia compact dialog chrome.
- Kept the established shared defaults unchanged for every other compact dialog.
- Opted Paragraph into WPF-matched input borders, selection brush, combo/tab fills, and disabled-field fill.
- Added a focused test proving Paragraph uses the authority palette while shared defaults remain unchanged.

## Regression Gate

Representative fresh non-Paragraph captures (`font.initial`, `options.initial`, `legal-notices.initial`, and `backstage-info.open`) all captured successfully. The scoped Avalonia test lane passed 15/15, including common chrome, Legal Notices, Paragraph, and source-guard tests. Those regression artifacts are under `artifacts/freew-wave27-regression-*` and were not merged into the canonical report.

| Representative row | Existing canonical ratio | Fresh final ratio | Fresh semantic difference |
| --- | ---: | ---: | --- |
| `font.initial` | 0.171522 | 0.171477 | none |
| `options.initial` | 0.074128 | 0.074116 | none |
| `legal-notices.initial` | 0.103175 | 0.105715 | none |
| `backstage-info.open` | 0.094676 | 0.094676 | action-button-order (existing semantic classification) |

The small Legal Notices raster movement is outside this slice and is not a source regression: the shared default chrome values remain unchanged and the targeted test lane passes.

Residual visual differences are platform text rasterization and remaining native/template border details; the target remains correctly classified as a genuine visual mismatch.
