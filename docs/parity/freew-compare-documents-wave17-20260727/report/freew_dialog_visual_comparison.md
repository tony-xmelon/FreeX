# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **8**. Captured WPF: **4**. Captured Avalonia: **4**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (3.2% painted) | 4.84 % | 4.24 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (3.2% painted) | 4.87 % | 4.24 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (4.7% painted) | 7.25 % | 7.46 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (3.2% painted) | 5.09 % | 4.27 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.validation-error.png |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
