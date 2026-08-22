# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

**Evidence scope:** `canonical-inputs-only`. Rows and counts cover only the inventory and WPF/Avalonia capture manifests supplied to this compare invocation. Route-local evidence remains outside this aggregate until it is merged with --baseline and --refresh-route.

Inventory scenarios: **512**. Captured WPF: **221**. Captured Avalonia: **291**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.0% painted) | 14.51 % | 15.69 |  | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.0% painted) | 14.51 % | 15.69 |  | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.0% painted) | 14.51 % | 15.69 |  | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **pass** | pass (0.3% painted) | pass (0.4% painted) | 0.57 % | 0.71 |  | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **pass** | pass (0.3% painted) | pass (0.4% painted) | 0.57 % | 0.71 |  | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **pass** | pass (0.3% painted) | pass (0.4% painted) | 0.57 % | 0.71 |  | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.8% painted) | 3.58 % | 3.41 |  | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (12.4% painted) | 13.90 % | 11.06 |  | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **pass** | pass (1.7% painted) | pass (1.7% painted) | 1.56 % | 0.84 |  | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (7.1% painted) | 9.47 % | 7.54 |  | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **pass** | pass (1.2% painted) | pass (1.0% painted) | 1.55 % | 0.92 |  | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (3.3% painted) | pass (3.5% painted) | 4.10 % | 2.84 |  | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **pass** | pass (1.8% painted) | pass (1.9% painted) | 2.10 % | 1.75 |  | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.0% painted) | pass (7.7% painted) | 8.87 % | 6.44 |  | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.4% painted) | pass (12.0% painted) | 9.63 % | 6.69 |  | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **pass** | pass (2.5% painted) | pass (2.7% painted) | 2.97 % | 2.17 |  | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **pass** | pass (2.1% painted) | pass (2.2% painted) | 2.33 % | 1.35 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **pass** | pass (3.8% painted) | pass (4.3% painted) | 2.13 % | 1.57 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **pass** | pass (3.8% painted) | pass (4.3% painted) | 2.13 % | 1.57 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.0% painted) | pass (10.4% painted) | 10.13 % | 5.60 |  | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.0% painted) | pass (10.4% painted) | 10.13 % | 5.60 |  | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.1% painted) | pass (10.4% painted) | 10.24 % | 5.73 |  | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 4.56 % | 4.01 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.7% painted) | 4.59 % | 4.04 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.8% painted) | 4.74 % | 4.18 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `cell-borders.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.6% painted) | pass (7.2% painted) | 7.65 % | 4.78 | focus,action-button-order | heatmaps/cell-borders.initial.png |
| `cell-borders.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.6% painted) | pass (7.2% painted) | 7.65 % | 4.78 | focus,action-button-order | heatmaps/cell-borders.populated.png |
| `cell-borders.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.6% painted) | pass (7.2% painted) | 7.71 % | 4.85 | focus,action-button-order | heatmaps/cell-borders.validation-error.png |
| `cell-shading.initial` | captured/captured | **pass** | pass (1.9% painted) | pass (1.7% painted) | 2.08 % | 1.48 |  | heatmaps/cell-shading.initial.png |
| `chart-axis-titles.initial` | captured/captured | **pass** | pass (1.3% painted) | pass (0.9% painted) | 2.03 % | 1.99 |  | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **pass** | pass (1.5% painted) | pass (1.3% painted) | 2.46 % | 2.55 |  | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **pass** | pass (1.4% painted) | pass (1.0% painted) | 2.16 % | 2.14 |  | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **pass** | pass (1.4% painted) | pass (1.0% painted) | 2.10 % | 2.03 |  | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **pass** | pass (1.4% painted) | pass (1.0% painted) | 2.10 % | 2.03 |  | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **pass** | pass (1.4% painted) | pass (1.1% painted) | 2.23 % | 2.17 |  | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **pass** | pass (0.9% painted) | pass (0.5% painted) | 1.21 % | 1.45 |  | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **pass** | pass (0.9% painted) | pass (0.8% painted) | 1.51 % | 1.85 |  | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **pass** | pass (0.9% painted) | pass (0.6% painted) | 1.32 % | 1.57 |  | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.2% painted) | 3.60 % | 2.55 |  | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.2% painted) | 3.60 % | 2.55 |  | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.2% painted) | pass (4.3% painted) | 3.76 % | 2.73 |  | heatmaps/columns.validation-error.png |
| `comment-list.initial` | captured/captured | **pass** | pass (0.3% painted) | pass (0.3% painted) | 0.55 % | 0.72 |  | heatmaps/comment-list.initial.png |
| `comment-list.populated` | captured/captured | **pass** | pass (0.3% painted) | pass (0.3% painted) | 0.55 % | 0.72 |  | heatmaps/comment-list.populated.png |
| `comment-list.validation-error` | captured/captured | **pass** | pass (0.3% painted) | pass (0.3% painted) | 0.55 % | 0.72 |  | heatmaps/comment-list.validation-error.png |
| `comment-reply.initial` | captured/captured | **pass** | pass (0.5% painted) | pass (0.5% painted) | 0.90 % | 1.07 |  | heatmaps/comment-reply.initial.png |
| `comment-reply.populated` | captured/captured | **pass** | pass (0.6% painted) | pass (0.6% painted) | 0.92 % | 1.09 |  | heatmaps/comment-reply.populated.png |
| `comment-reply.validation-error` | captured/captured | **pass** | pass (0.6% painted) | pass (0.6% painted) | 1.01 % | 1.17 |  | heatmaps/comment-reply.validation-error.png |
| `compare-documents.initial` | captured/captured | **pass** | pass (1.3% painted) | pass (1.9% painted) | 2.42 % | 2.48 |  | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **pass** | pass (1.3% painted) | pass (1.9% painted) | 2.42 % | 2.48 |  | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (3.7% painted) | 5.17 % | 5.64 |  | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **pass** | pass (1.2% painted) | pass (1.9% painted) | 2.42 % | 2.44 |  | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.6% painted) | 5.06 % | 3.93 | focus | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.6% painted) | 5.06 % | 3.93 | focus | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.6% painted) | 5.06 % | 3.93 | focus | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **pass** | pass (1.7% painted) | pass (1.4% painted) | 2.78 % | 2.44 |  | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **pass** | pass (1.7% painted) | pass (1.4% painted) | 2.78 % | 2.44 |  | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **pass** | pass (1.8% painted) | pass (1.4% painted) | 2.93 % | 2.61 |  | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.8% painted) | 10.44 % | 8.56 |  | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.8% painted) | 10.44 % | 8.56 |  | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.8% painted) | 10.47 % | 8.59 |  | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **pass** | pass (1.5% painted) | pass (1.7% painted) | 1.94 % | 1.55 |  | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **pass** | pass (1.5% painted) | pass (1.7% painted) | 1.94 % | 1.55 |  | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **pass** | pass (1.6% painted) | pass (1.7% painted) | 2.03 % | 1.68 |  | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 4.11 % | 3.62 |  | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 4.11 % | 3.62 |  | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 4.11 % | 3.62 |  | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.4% painted) | 3.97 % | 3.85 |  | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.4% painted) | 3.97 % | 3.85 |  | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.4% painted) | 3.97 % | 3.85 |  | heatmaps/document-inspector.validation-error.png |
| `draw-table-dimension.initial` | captured/captured | **pass** | pass (0.7% painted) | pass (0.6% painted) | 1.26 % | 1.46 |  | heatmaps/draw-table-dimension.initial.png |
| `draw-table-dimension.populated` | captured/captured | **pass** | pass (0.7% painted) | pass (0.6% painted) | 1.26 % | 1.46 |  | heatmaps/draw-table-dimension.populated.png |
| `draw-table-dimension.validation-error` | captured/captured | **pass** | pass (0.7% painted) | pass (0.7% painted) | 1.37 % | 1.58 |  | heatmaps/draw-table-dimension.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **pass** | pass (1.3% painted) | pass (1.5% painted) | 2.83 % | 2.94 |  | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **pass** | pass (1.3% painted) | pass (1.5% painted) | 2.83 % | 2.94 |  | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **pass** | pass (1.3% painted) | pass (1.6% painted) | 2.88 % | 3.00 |  | heatmaps/drop-cap-options.validation-error.png |
| `field-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 5.04 % | 3.56 |  | heatmaps/field-picker.initial.png |
| `field-picker.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 5.04 % | 3.56 |  | heatmaps/field-picker.populated.png |
| `field-picker.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (5.0% painted) | 5.04 % | 3.56 |  | heatmaps/field-picker.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.9% painted) | pass (5.1% painted) | 7.10 % | 4.20 |  | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.9% painted) | pass (5.1% painted) | 7.15 % | 4.26 |  | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.2% painted) | 7.23 % | 4.35 |  | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (11.0% painted) | 13.83 % | 9.74 |  | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (11.1% painted) | 13.90 % | 9.81 |  | heatmaps/font.populated.png |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.5% painted) | pass (11.1% painted) | 14.00 % | 9.92 |  | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.7% painted) | pass (13.8% painted) | 8.41 % | 4.71 |  | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.7% painted) | pass (13.8% painted) | 8.60 % | 4.87 |  | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (14.1% painted) | 8.76 % | 5.18 |  | heatmaps/footnote-endnote-options.validation-error.png |
| `hyperlink.initial` | captured/captured | **pass** | pass (0.9% painted) | pass (1.3% painted) | 2.20 % | 1.75 |  | heatmaps/hyperlink.initial.png |
| `hyperlink.populated` | captured/captured | **pass** | pass (0.9% painted) | pass (1.1% painted) | 2.08 % | 1.83 |  | heatmaps/hyperlink.populated.png |
| `hyperlink.validation-error` | captured/captured | **pass** | pass (1.0% painted) | pass (1.3% painted) | 2.30 % | 1.91 |  | heatmaps/hyperlink.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **pass** | pass (1.5% painted) | pass (1.5% painted) | 2.99 % | 3.29 |  | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **pass** | pass (1.5% painted) | pass (1.5% painted) | 2.99 % | 3.29 |  | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (1.6% painted) | pass (1.6% painted) | 3.14 % | 3.46 |  | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.3% painted) | pass (9.1% painted) | 12.99 % | 16.43 |  | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **pass** | pass (1.4% painted) | pass (1.4% painted) | 1.27 % | 1.25 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **pass** | pass (1.5% painted) | pass (1.5% painted) | 1.38 % | 1.37 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (1.9% painted) | 3.24 % | 3.07 | focus | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (1.9% painted) | 3.24 % | 3.07 | focus | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.0% painted) | pass (2.0% painted) | 3.40 % | 3.25 | focus | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.9% painted) | pass (3.8% painted) | 3.01 % | 2.53 |  | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.1% painted) | 3.30 % | 2.93 |  | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (3.9% painted) | 3.11 % | 2.64 |  | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (2.2% painted) | 3.74 % | 3.31 |  | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (2.2% painted) | 3.74 % | 3.31 |  | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.3% painted) | 3.81 % | 3.40 |  | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.0% painted) | pass (6.9% painted) | 3.95 % | 2.72 | focus | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.0% painted) | pass (6.9% painted) | 3.95 % | 2.72 | focus | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.1% painted) | pass (7.0% painted) | 4.06 % | 2.84 | focus | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **pass** | pass (1.1% painted) | pass (1.2% painted) | 1.99 % | 2.07 |  | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **pass** | pass (1.1% painted) | pass (1.2% painted) | 1.99 % | 2.07 |  | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **pass** | pass (1.2% painted) | pass (1.2% painted) | 2.07 % | 2.16 |  | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (22.2% painted) | pass (20.1% painted) | 7.47 % | 4.75 | focus | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (22.2% painted) | pass (20.1% painted) | 7.47 % | 4.75 | focus | heatmaps/insert-chart.populated.png |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (22.2% painted) | pass (20.1% painted) | 7.45 % | 4.72 | focus | heatmaps/insert-chart.validation-error.png |
| `insert-index.initial` | captured/captured | **pass** | pass (1.0% painted) | pass (1.0% painted) | 1.81 % | 1.99 |  | heatmaps/insert-index.initial.png |
| `insert-index.populated` | captured/captured | **pass** | pass (1.0% painted) | pass (1.3% painted) | 2.10 % | 2.37 |  | heatmaps/insert-index.populated.png |
| `insert-index.validation-error` | captured/captured | **pass** | pass (1.1% painted) | pass (1.1% painted) | 1.95 % | 2.14 |  | heatmaps/insert-index.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (10.3% painted) | 10.12 % | 5.13 |  | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (10.3% painted) | 10.12 % | 5.13 |  | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (7.1% painted) | 6.08 % | 4.35 |  | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.3% painted) | pass (7.7% painted) | 9.17 % | 10.26 |  | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (11.7% painted) | pass (14.7% painted) | 19.83 % | 21.54 |  | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (13.2% painted) | 18.34 % | 19.68 |  | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (7.3% painted) | pass (7.7% painted) | 9.17 % | 10.26 |  | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (14.4% painted) | 18.90 % | 21.19 |  | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.2% painted) | pass (14.4% painted) | 19.06 % | 21.22 |  | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.3% painted) | pass (3.8% painted) | 5.61 % | 2.74 |  | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.3% painted) | pass (3.8% painted) | 5.61 % | 2.74 |  | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.4% painted) | pass (3.9% painted) | 5.77 % | 2.92 |  | heatmaps/line-number-options.validation-error.png |
| `link-bookmark.initial` | captured/captured | **pass** | pass (0.7% painted) | pass (0.7% painted) | 0.94 % | 0.86 |  | heatmaps/link-bookmark.initial.png |
| `link-bookmark.populated` | captured/captured | **pass** | pass (0.7% painted) | pass (0.7% painted) | 0.94 % | 0.86 |  | heatmaps/link-bookmark.populated.png |
| `link-bookmark.validation-error` | captured/captured | **pass** | pass (0.7% painted) | pass (0.7% painted) | 0.94 % | 0.86 |  | heatmaps/link-bookmark.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (6.7% painted) | 7.64 % | 4.43 | focus | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (6.7% painted) | 7.64 % | 4.43 | focus | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (6.7% painted) | 7.64 % | 4.43 | focus | heatmaps/manage-styles.validation-error.png |
| `manual-hyphenation.initial` | captured/captured | **pass** | pass (4.3% painted) | pass (4.3% painted) | 2.55 % | 1.79 |  | heatmaps/manual-hyphenation.initial.png |
| `manual-hyphenation.populated` | captured/captured | **pass** | pass (4.3% painted) | pass (4.3% painted) | 2.59 % | 1.79 |  | heatmaps/manual-hyphenation.populated.png |
| `manual-hyphenation.validation-error` | captured/captured | **pass** | pass (4.3% painted) | pass (4.3% painted) | 2.59 % | 1.79 |  | heatmaps/manual-hyphenation.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.0% painted) | 3.24 % | 2.40 |  | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.3% painted) | 3.56 % | 2.84 |  | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (5.1% painted) | 3.37 % | 2.54 |  | heatmaps/mark-citation.validation-error.png |
| `mark-index-entry.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (7.1% painted) | 10.54 % | 4.99 |  | heatmaps/mark-index-entry.initial.png |
| `mark-index-entry.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (6.9% painted) | 10.36 % | 5.20 |  | heatmaps/mark-index-entry.populated.png |
| `mark-index-entry.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (7.2% painted) | 10.65 % | 5.09 |  | heatmaps/mark-index-entry.validation-error.png |
| `multilevel-list.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (22.8% painted) | 3.95 % | 4.03 |  | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (22.8% painted) | 3.95 % | 4.03 |  | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (23.0% painted) | 4.17 % | 4.27 |  | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.3% painted) | 4.78 % | 3.50 |  | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.3% painted) | 4.81 % | 3.53 |  | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (8.8% painted) | 10.48 % | 9.13 |  | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (5.1% painted) | 7.67 % | 7.65 |  | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.3% painted) | 4.78 % | 3.50 |  | heatmaps/options.tab-general.png |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.4% painted) | 4.90 % | 3.62 |  | heatmaps/options.validation-error.png |
| `page-number-format.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.3% painted) | pass (12.4% painted) | 9.57 % | 4.50 |  | heatmaps/page-number-format.initial.png |
| `page-number-format.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.3% painted) | pass (12.4% painted) | 9.57 % | 4.50 |  | heatmaps/page-number-format.populated.png |
| `page-number-format.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.3% painted) | pass (12.5% painted) | 9.69 % | 4.64 |  | heatmaps/page-number-format.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (15.5% painted) | pass (14.8% painted) | 9.66 % | 6.10 |  | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (15.5% painted) | pass (14.8% painted) | 9.66 % | 6.10 |  | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (8.8% painted) | 6.69 % | 4.59 |  | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (15.5% painted) | pass (14.8% painted) | 9.66 % | 6.10 |  | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (5.2% painted) | 4.46 % | 2.99 |  | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.6% painted) | pass (14.8% painted) | 9.77 % | 6.21 |  | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (11.3% painted) | 12.43 % | 10.34 |  | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (11.3% painted) | 12.43 % | 10.34 |  | heatmaps/paragraph.populated.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.5% painted) | pass (12.1% painted) | 13.13 % | 11.06 |  | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **pass** | pass (0.5% painted) | pass (0.7% painted) | 1.13 % | 1.41 |  | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **pass** | pass (0.6% painted) | pass (0.7% painted) | 1.17 % | 1.44 |  | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (11.5% painted) | 8.76 % | 7.14 |  | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (11.5% painted) | 8.76 % | 7.14 |  | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (11.5% painted) | 8.76 % | 7.14 |  | heatmaps/paste-special.validation-error.png |
| `proofing-language.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (6.8% painted) | 7.50 % | 7.03 |  | heatmaps/proofing-language.initial.png |
| `proofing-language.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (6.8% painted) | 7.50 % | 7.03 |  | heatmaps/proofing-language.populated.png |
| `proofing-language.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (6.8% painted) | 7.50 % | 7.03 |  | heatmaps/proofing-language.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (3.5% painted) | 6.64 % | 5.17 |  | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.6% painted) | pass (3.6% painted) | 6.89 % | 5.44 |  | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.6% painted) | pass (3.5% painted) | 6.79 % | 5.34 |  | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.0% painted) | 5.61 % | 4.21 |  | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.1% painted) | 5.62 % | 4.22 |  | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (4.1% painted) | 5.66 % | 4.25 |  | heatmaps/restrict-editing.validation-error.png |
| `save-compatibility-warning.initial` | captured/captured | **pass** | pass (0.8% painted) | pass (0.9% painted) | 1.33 % | 1.48 |  | heatmaps/save-compatibility-warning.initial.png |
| `save-compatibility-warning.populated` | captured/captured | **pass** | pass (0.8% painted) | pass (0.9% painted) | 1.33 % | 1.48 |  | heatmaps/save-compatibility-warning.populated.png |
| `save-compatibility-warning.validation-error` | captured/captured | **pass** | pass (0.8% painted) | pass (0.9% painted) | 1.33 % | 1.48 |  | heatmaps/save-compatibility-warning.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `screen-tip.initial` | captured/captured | **pass** | pass (0.6% painted) | pass (0.6% painted) | 1.29 % | 1.26 |  | heatmaps/screen-tip.initial.png |
| `screen-tip.populated` | captured/captured | **pass** | pass (0.6% painted) | pass (0.7% painted) | 1.34 % | 1.34 |  | heatmaps/screen-tip.populated.png |
| `screen-tip.validation-error` | captured/captured | **pass** | pass (0.6% painted) | pass (0.7% painted) | 1.42 % | 1.43 |  | heatmaps/screen-tip.validation-error.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.3% painted) | pass (4.4% painted) | 6.72 % | 4.18 |  | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.3% painted) | pass (4.4% painted) | 6.72 % | 4.18 |  | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.3% painted) | pass (4.4% painted) | 6.72 % | 4.18 |  | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.5% painted) | pass (23.4% painted) | 10.70 % | 8.01 |  | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.7% painted) | pass (23.6% painted) | 10.80 % | 8.19 |  | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.5% painted) | pass (23.4% painted) | 10.70 % | 8.01 |  | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **pass** | pass (3.3% painted) | pass (3.2% painted) | 2.20 % | 1.89 |  | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (4.9% painted) | 3.08 % | 2.18 |  | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.8% painted) | pass (5.3% painted) | 3.46 % | 2.74 |  | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.9% painted) | pass (5.1% painted) | 3.36 % | 2.43 |  | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.0% painted) | pass (7.4% painted) | 3.90 % | 2.16 |  | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.0% painted) | pass (7.4% painted) | 3.99 % | 2.27 |  | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.0% painted) | pass (7.4% painted) | 3.90 % | 2.16 |  | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.4% painted) | pass (9.8% painted) | 7.73 % | 4.91 |  | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.4% painted) | pass (9.8% painted) | 7.73 % | 4.91 |  | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (17.0% painted) | pass (17.4% painted) | 14.23 % | 7.84 |  | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **pass** | pass (1.9% painted) | pass (2.1% painted) | 2.55 % | 2.10 |  | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (5.4% painted) | 4.72 % | 3.68 |  | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (9.4% painted) | pass (9.8% painted) | 7.73 % | 4.91 |  | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.5% painted) | pass (9.9% painted) | 7.84 % | 5.02 |  | heatmaps/table-properties.validation-error.png |
| `table-text-conversion.initial` | captured/captured | **pass** | pass (3.7% painted) | pass (4.2% painted) | 1.83 % | 1.62 |  | heatmaps/table-text-conversion.initial.png |
| `table-text-conversion.populated` | captured/captured | **pass** | pass (3.7% painted) | pass (4.2% painted) | 1.83 % | 1.62 |  | heatmaps/table-text-conversion.populated.png |
| `table-text-conversion.validation-error` | captured/captured | **pass** | pass (3.7% painted) | pass (4.2% painted) | 1.83 % | 1.62 |  | heatmaps/table-text-conversion.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.6% painted) | pass (9.4% painted) | 8.59 % | 4.22 |  | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.6% painted) | pass (9.4% painted) | 8.62 % | 4.24 |  | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (9.4% painted) | 8.71 % | 4.33 |  | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (2.6% painted) | 4.47 % | 4.32 |  | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.6% painted) | 4.58 % | 4.47 |  | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.6% painted) | 4.59 % | 4.49 |  | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **pass** | pass (1.8% painted) | pass (0.7% painted) | 2.31 % | 2.56 |  | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **pass** | pass (1.8% painted) | pass (0.7% painted) | 2.31 % | 2.56 |  | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **pass** | pass (1.8% painted) | pass (0.7% painted) | 2.31 % | 2.56 |  | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **pass** | pass (1.3% painted) | pass (1.1% painted) | 2.38 % | 2.52 |  | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **pass** | pass (1.3% painted) | pass (1.1% painted) | 2.38 % | 2.52 |  | heatmaps/zoom.populated.png |
| `zoom.validation-error` | captured/captured | **pass** | pass (1.3% painted) | pass (1.1% painted) | 2.44 % | 2.57 |  | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.2% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.2% painted) |  |  |  |  |
| `caption.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `caption.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `caption.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.4% painted) |  |  |  |  |
| `change-case.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `change-case.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `change-case.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `character-formatting-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `character-formatting-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `character-formatting-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.0% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.0% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.1% painted) |  |  |  |  |
| `header-footer-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `header-footer-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `header-footer-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.4% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (13.9% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (13.9% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (13.9% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.5% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.5% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `quick-part-name.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `quick-part-name.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `quick-part-name.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `set-as-default-confirmation.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `set-as-default-confirmation.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `set-as-default-confirmation.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.9% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.9% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.8% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.6% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.6% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.6% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.2% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.4% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.3% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.4% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.4% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
