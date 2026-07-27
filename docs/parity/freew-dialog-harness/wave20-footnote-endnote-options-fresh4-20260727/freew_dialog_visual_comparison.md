# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **6**. Captured WPF: **3**. Captured Avalonia: **3**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.9% painted) | 7.28 % | 5.25 |  | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.9% painted) | 7.45 % | 5.39 |  | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.0% painted) | pass (15.3% painted) | 7.62 % | 5.74 |  | heatmaps/footnote-endnote-options.validation-error.png |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
