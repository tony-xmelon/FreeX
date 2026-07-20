# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **457**. Captured WPF: **186**. Captured Avalonia: **271**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (0.1% painted) | 16.82 % | 32.06 | focus,default-button,cancel-button,action-button-order | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (0.2% painted) | 16.90 % | 32.14 | focus,default-button,cancel-button,action-button-order | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (1.6% painted) | pass (0.1% painted) | 10.38 % | 23.05 | focus,default-button,cancel-button,action-button-order | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.4% painted) | 10.14 % | 23.81 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.4% painted) | 10.14 % | 23.81 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.4% painted) | 10.14 % | 23.81 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (38.2% painted) | 44.69 % | 83.72 | action-button-order | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (36.7% painted) | 49.15 % | 83.33 | action-button-order | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (35.7% painted) | 48.80 % | 84.54 | action-button-order | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (38.8% painted) | 48.17 % | 84.00 | action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **genuine-visual-mismatch** | pass (1.2% painted) | pass (35.7% painted) | 42.04 % | 82.49 | action-button-order | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (37.2% painted) | 51.53 % | 86.05 | action-button-order | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (35.7% painted) | 42.50 % | 82.56 | action-button-order | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (8.7% painted) | 22.44 % | 32.50 |  | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (36.7% painted) | 49.39 % | 82.14 | action-button-order | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (36.4% painted) | 43.36 % | 82.82 | action-button-order | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (30.1% painted) | 39.39 % | 27.05 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (30.1% painted) | 39.39 % | 27.05 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (30.1% painted) | 39.39 % | 27.05 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.2% painted) | 24.58 % | 30.35 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.2% painted) | 24.58 % | 30.35 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-page-border` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-shading` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.2% painted) | 24.70 % | 30.51 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (17.8% painted) | 29.52 % | 28.16 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (17.8% painted) | 29.53 % | 28.18 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (17.7% painted) | 29.53 % | 28.21 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.2% painted) | 11.53 % | 24.36 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.6% painted) | 11.97 % | 24.94 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.66 % | 24.52 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.64 % | 24.42 | default-button,cancel-button,action-button-order | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.64 % | 24.42 | default-button,cancel-button,action-button-order | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.4% painted) | 11.75 % | 24.57 | default-button,cancel-button,action-button-order | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (0.8% painted) | 10.71 % | 23.67 | default-button,cancel-button,action-button-order | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (1.1% painted) | 11.01 % | 24.08 | default-button,cancel-button,action-button-order | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (0.9% painted) | 10.84 % | 23.84 | default-button,cancel-button,action-button-order | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.1% painted) | 14.71 % | 25.29 | action-button-order | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.1% painted) | 14.71 % | 25.29 | action-button-order | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.2% painted) | 14.86 % | 25.49 | action-button-order | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.1% painted) | 12.89 % | 25.86 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.1% painted) | 12.92 % | 25.85 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (23.9% painted) | 33.23 % | 29.13 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.2% painted) | 12.98 % | 25.83 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.5% painted) | 42.05 % | 30.19 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.5% painted) | 42.05 % | 30.19 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.5% painted) | 42.05 % | 30.19 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (1.4% painted) | 12.63 % | 25.01 |  | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (1.4% painted) | 12.63 % | 25.01 |  | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (1.5% painted) | 12.77 % | 25.20 |  | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (5.8% painted) | 20.74 % | 32.52 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (5.8% painted) | 20.74 % | 32.52 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (5.9% painted) | 20.74 % | 32.52 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.5% painted) | 12.60 % | 25.11 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.5% painted) | 12.60 % | 25.11 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.5% painted) | 12.68 % | 25.21 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.4% painted) | 37.35 % | 29.39 | default-button,cancel-button,action-button-order | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.4% painted) | 37.35 % | 29.39 | default-button,cancel-button,action-button-order | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.4% painted) | 37.35 % | 29.39 | default-button,cancel-button,action-button-order | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.1% painted) | 13.31 % | 25.62 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.1% painted) | 13.31 % | 25.62 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.1% painted) | 13.31 % | 25.62 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.4% painted) | 12.26 % | 25.28 | action-button-order | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.4% painted) | 12.26 % | 25.28 | action-button-order | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 12.31 % | 25.34 | action-button-order | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (2.5% painted) | 19.22 % | 28.43 | action-button-order | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (2.4% painted) | 19.12 % | 28.42 | action-button-order | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.8% painted) | pass (2.6% painted) | 19.31 % | 28.59 | action-button-order | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.73 % | 46.18 | default-button,cancel-button,action-button-order | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.73 % | 46.18 | default-button,cancel-button,action-button-order | heatmaps/font.populated.png |
| `font.tab-advanced` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `font.tab-font` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.73 % | 46.18 | default-button,cancel-button,action-button-order | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.3% painted) | 25.16 % | 29.39 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.3% painted) | 25.16 % | 29.39 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.4% painted) | 25.28 % | 29.55 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.6% painted) | 12.66 % | 25.71 | action-button-order | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.6% painted) | 12.66 % | 25.71 | action-button-order | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (1.6% painted) | 12.78 % | 25.88 | action-button-order | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (8.8% painted) | 28.19 % | 47.34 | action-button-order | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (0.7% painted) | 11.56 % | 23.89 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (0.8% painted) | 11.67 % | 24.02 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.2% painted) | 13.54 % | 26.17 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.2% painted) | 13.54 % | 26.17 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.3% painted) | 13.68 % | 26.37 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (1.8% painted) | 14.36 % | 25.32 | default-button,cancel-button,action-button-order | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (2.1% painted) | 14.65 % | 25.73 | default-button,cancel-button,action-button-order | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (1.9% painted) | 14.48 % | 25.48 | default-button,cancel-button,action-button-order | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.5% painted) | 14.08 % | 26.63 | default-button,cancel-button,action-button-order | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.5% painted) | 14.08 % | 26.63 | default-button,cancel-button,action-button-order | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.6% painted) | 14.16 % | 26.72 | default-button,cancel-button,action-button-order | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (1.8% painted) | 17.44 % | 26.15 | default-button,cancel-button,action-button-order | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (1.8% painted) | 17.44 % | 26.15 | default-button,cancel-button,action-button-order | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (1.9% painted) | 17.55 % | 26.28 | default-button,cancel-button,action-button-order | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 11.77 % | 24.62 | default-button,cancel-button,action-button-order | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 11.77 % | 24.62 | default-button,cancel-button,action-button-order | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.5% painted) | 11.84 % | 24.72 | default-button,cancel-button,action-button-order | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.1% painted) | 32.35 % | 30.46 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.1% painted) | 32.35 % | 30.46 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.1% painted) | 32.34 % | 30.41 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (22.2% painted) | 37.12 % | 30.95 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (22.2% painted) | 37.12 % | 30.95 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (22.3% painted) | 36.87 % | 29.61 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (9.3% painted) | 16.90 % | 20.04 | focus | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.4% painted) | pass (14.2% painted) | 27.78 % | 32.19 | focus | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (12.5% painted) | pass (13.5% painted) | 24.99 % | 28.26 | focus | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (9.3% painted) | 16.90 % | 20.04 | focus | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (14.4% painted) | pass (15.2% painted) | 28.48 % | 32.35 | focus | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.7% painted) | pass (16.9% painted) | 30.18 % | 34.77 | focus | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (1.0% painted) | 14.78 % | 25.24 |  | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (1.0% painted) | 14.78 % | 25.24 |  | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (1.0% painted) | 14.92 % | 25.44 |  | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.2% painted) | 62.20 % | 46.22 | action-button-order | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.2% painted) | 62.20 % | 46.22 | action-button-order | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.2% painted) | 62.20 % | 46.22 | action-button-order | heatmaps/manage-styles.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.2% painted) | pass (1.4% painted) | 15.79 % | 25.78 | cancel-button,action-button-order | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (1.5% painted) | 15.83 % | 25.90 | cancel-button,action-button-order | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (1.5% painted) | 15.86 % | 25.96 | cancel-button,action-button-order | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.3% painted) | 38.72 % | 45.31 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.3% painted) | 38.72 % | 45.31 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.4% painted) | 38.89 % | 45.49 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.5% painted) | 14.99 % | 26.06 | default-button,cancel-button,action-button-order | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.5% painted) | 15.02 % | 26.10 | default-button,cancel-button,action-button-order | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (4.0% painted) | 19.32 % | 30.85 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (6.4% painted) | 19.18 % | 32.81 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.5% painted) | 14.99 % | 26.06 | default-button,cancel-button,action-button-order | heatmaps/options.tab-general.png |
| `options.tab-replace` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.5% painted) | 15.12 % | 26.22 | default-button,cancel-button,action-button-order | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (3.2% painted) | 24.27 % | 30.03 | action-button-order | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (3.2% painted) | 24.27 % | 30.03 | action-button-order | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (3.3% painted) | 21.51 % | 29.35 | action-button-order | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (3.2% painted) | 24.27 % | 30.03 | action-button-order | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (2.1% painted) | 16.29 % | 26.16 | action-button-order | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (3.3% painted) | 24.41 % | 30.21 | action-button-order | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.1% painted) | 34.64 % | 50.86 | action-button-order | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.1% painted) | 34.64 % | 50.86 | action-button-order | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.1% painted) | 34.64 % | 50.86 | action-button-order | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (3.0% painted) | 32.13 % | 49.34 | action-button-order | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.2% painted) | 34.76 % | 51.05 | action-button-order | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **genuine-visual-mismatch** | pass (1.7% painted) | pass (1.0% painted) | 10.95 % | 23.85 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (1.0% painted) | 10.99 % | 23.87 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.2% painted) | 76.62 % | 66.55 | default-button,cancel-button,action-button-order | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.2% painted) | 76.62 % | 66.55 | default-button,cancel-button,action-button-order | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.2% painted) | 76.62 % | 66.55 | default-button,cancel-button,action-button-order | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (2.2% painted) | 14.46 % | 26.77 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.9% painted) | pass (2.3% painted) | 14.59 % | 26.93 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.9% painted) | pass (2.3% painted) | 14.60 % | 26.96 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.6% painted) | 16.14 % | 26.64 | default-button,action-button-order | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.6% painted) | 16.16 % | 26.66 | default-button,action-button-order | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.7% painted) | 16.19 % | 26.69 | default-button,action-button-order | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (3.8% painted) | 16.77 % | 27.27 | default-button,cancel-button,action-button-order | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (3.8% painted) | 16.81 % | 27.32 | default-button,cancel-button,action-button-order | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (3.8% painted) | 16.77 % | 27.27 | default-button,cancel-button,action-button-order | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (2.5% painted) | 40.41 % | 46.41 | default-button,cancel-button,action-button-order | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (2.6% painted) | 40.43 % | 46.57 | default-button,cancel-button,action-button-order | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (2.6% painted) | 40.43 % | 46.57 | default-button,cancel-button,action-button-order | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (32.9% painted) | pass (1.8% painted) | 41.67 % | 35.54 | focus | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (1.3% painted) | 15.34 % | 25.48 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (1.7% painted) | 15.73 % | 26.06 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.1% painted) | pass (1.6% painted) | 15.66 % | 25.80 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (0.9% painted) | 18.21 % | 25.88 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (0.9% painted) | 18.21 % | 25.88 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (0.9% painted) | 18.21 % | 25.88 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.4% painted) | pass (5.3% painted) | 23.57 % | 31.49 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.4% painted) | pass (5.5% painted) | 23.70 % | 31.68 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (4.5% painted) | 19.70 % | 29.48 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **genuine-visual-mismatch** | pass (3.2% painted) | pass (2.3% painted) | 13.02 % | 24.81 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (3.4% painted) | 16.97 % | 27.38 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (11.4% painted) | pass (5.3% painted) | 23.57 % | 31.49 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (11.5% painted) | pass (5.8% painted) | 24.03 % | 32.00 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (18.7% painted) | 36.34 % | 29.64 | default-button,cancel-button,action-button-order | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (18.7% painted) | 36.37 % | 29.68 | default-button,cancel-button,action-button-order | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (18.8% painted) | 36.44 % | 29.83 | default-button,cancel-button,action-button-order | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (2.6% painted) | 14.73 % | 27.62 | default-button,cancel-button,action-button-order | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (2.6% painted) | 14.84 % | 27.81 | default-button,cancel-button,action-button-order | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (2.6% painted) | 14.85 % | 27.82 | default-button,cancel-button,action-button-order | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.7% painted) | 11.17 % | 24.28 | default-button,cancel-button,action-button-order | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.7% painted) | 11.17 % | 24.28 | default-button,cancel-button,action-button-order | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.7% painted) | 11.17 % | 24.28 | default-button,cancel-button,action-button-order | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.0% painted) | 11.69 % | 24.28 | default-button,cancel-button,action-button-order | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.0% painted) | 11.69 % | 24.28 | default-button,cancel-button,action-button-order | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.1% painted) | 11.74 % | 24.35 | default-button,cancel-button,action-button-order | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.5% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.5% painted) |  |  |  |  |
| `cell-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `cell-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `cell-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `comment-list.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.3% painted) |  |  |  |  |
| `comment-list.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.3% painted) |  |  |  |  |
| `comment-list.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.3% painted) |  |  |  |  |
| `comment-reply.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-reply.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-reply.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `draw-table-dimension.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `draw-table-dimension.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `draw-table-dimension.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `field-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `field-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `field-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `hyperlink.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `hyperlink.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.1% painted) |  |  |  |  |
| `hyperlink.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.2% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `link-bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `link-bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `link-bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (26.3% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (26.3% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (26.3% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.6% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `page-number-format.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.6% painted) |  |  |  |  |
| `page-number-format.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.6% painted) |  |  |  |  |
| `page-number-format.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.6% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `proofing-language.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `proofing-language.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `proofing-language.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `quick-part-name.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `quick-part-name.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `quick-part-name.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `quick-part.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `quick-part.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `save-compatibility-warning.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `save-compatibility-warning.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `save-compatibility-warning.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `screen-tip.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `screen-tip.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `screen-tip.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `set-as-default-confirmation.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `set-as-default-confirmation.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `set-as-default-confirmation.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.2% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.4% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `table-text-conversion.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `table-text-conversion.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `table-text-conversion.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.4% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.4% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
