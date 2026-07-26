# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **8**. Captured WPF: **4**. Captured Avalonia: **4**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (17.4% painted) | 17.76 % | 17.48 |  | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (17.4% painted) | 17.76 % | 17.48 |  | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (17.4% painted) | 17.76 % | 17.48 |  | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.3% painted) | pass (18.3% painted) | 18.60 % | 18.65 |  | heatmaps/paragraph.validation-error.png |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
