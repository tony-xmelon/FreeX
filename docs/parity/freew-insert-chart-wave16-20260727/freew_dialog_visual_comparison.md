# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **6**. Captured WPF: **3**. Captured Avalonia: **3**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.43 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.43 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.41 % | 4.91 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.validation-error.png |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
