# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **459**. Captured WPF: **186**. Captured Avalonia: **273**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.54 % | 16.78 |  | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.54 % | 16.78 |  | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.9% painted) | 1.76 % | 2.06 |  | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (30.6% painted) | 41.66 % | 79.04 | action-button-order | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (30.4% painted) | 47.29 % | 80.93 | action-button-order | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (29.5% painted) | 46.17 % | 80.77 | action-button-order | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (32.2% painted) | 45.16 % | 80.29 | action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **genuine-visual-mismatch** | pass (1.2% painted) | pass (29.5% painted) | 39.57 % | 77.40 | action-button-order | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (30.8% painted) | 49.22 % | 82.59 | action-button-order | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (29.5% painted) | 40.07 % | 77.86 | action-button-order | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (8.5% painted) | 14.14 % | 11.67 |  | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (30.2% painted) | 47.46 % | 80.61 | action-button-order | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (30.2% painted) | 41.18 % | 78.59 | action-button-order | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (12.8% painted) | 21.09 % | 9.42 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (12.8% painted) | 21.09 % | 9.42 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-page-border` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-shading` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (12.9% painted) | 21.21 % | 9.58 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.5% painted) | 6.07 % | 4.83 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.5% painted) | 6.09 % | 4.85 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.4% painted) | 6.09 % | 4.88 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.1% painted) | 3.22 % | 2.68 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.5% painted) | 3.66 % | 3.26 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.34 % | 2.84 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.21 % | 2.70 | default-button,cancel-button,action-button-order | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.21 % | 2.70 | default-button,cancel-button,action-button-order | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.3% painted) | 3.32 % | 2.85 | default-button,cancel-button,action-button-order | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **semantic-mismatch** | pass (1.8% painted) | pass (1.8% painted) | 1.41 % | 1.63 | default-button,cancel-button,action-button-order | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **semantic-mismatch** | pass (1.9% painted) | pass (2.0% painted) | 1.70 % | 2.04 | default-button,cancel-button,action-button-order | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **semantic-mismatch** | pass (1.9% painted) | pass (1.8% painted) | 1.54 % | 1.80 | default-button,cancel-button,action-button-order | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.1% painted) | 5.97 % | 3.47 |  | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.1% painted) | 5.97 % | 3.47 |  | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.5% painted) | pass (3.2% painted) | 6.12 % | 3.67 |  | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (4.0% painted) | 5.60 % | 4.50 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (4.0% painted) | 5.63 % | 4.50 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (25.9% painted) | 27.40 % | 10.49 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (4.0% painted) | 5.85 % | 4.53 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.39 |  | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.39 |  | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (2.6% painted) | 4.67 % | 3.57 |  | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.15 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.65 % | 4.05 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.65 % | 4.05 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.69 % | 4.13 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 | default-button,cancel-button,action-button-order | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 | default-button,cancel-button,action-button-order | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 | default-button,cancel-button,action-button-order | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.5% painted) | 5.80 % | 4.06 |  | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.5% painted) | 5.80 % | 4.06 |  | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.6% painted) | 5.85 % | 4.13 |  | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (7.0% painted) | 14.89 % | 7.51 |  | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (6.8% painted) | 14.79 % | 7.51 |  | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (7.0% painted) | 14.98 % | 7.68 |  | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (16.3% painted) | 17.15 % | 13.48 |  | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.5% painted) | pass (16.3% painted) | 17.22 % | 13.60 |  | heatmaps/font.populated.png |
| `font.tab-advanced` | captured/captured | **genuine-visual-mismatch** | pass (17.8% painted) | pass (16.2% painted) | 15.94 % | 12.14 |  | heatmaps/font.tab-advanced.png |
| `font.tab-font` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (16.3% painted) | 17.15 % | 13.48 |  | heatmaps/font.tab-font.png |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (16.5% painted) | 17.44 % | 13.87 |  | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (5.3% painted) | 19.63 % | 8.39 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (5.3% painted) | 19.63 % | 8.39 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.0% painted) | pass (5.4% painted) | 19.76 % | 8.55 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.40 |  | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.40 |  | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.7% painted) | 5.37 % | 4.57 |  | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.7% painted) | pass (45.8% painted) | 49.54 % | 31.96 | action-button-order | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.60 % | 2.41 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.5% painted) | 3.70 % | 2.54 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.70 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.70 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (3.1% painted) | 5.99 % | 4.90 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (3.3% painted) | 4.53 % | 3.16 | default-button,cancel-button,action-button-order | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (3.5% painted) | 4.83 % | 3.57 | default-button,cancel-button,action-button-order | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (3.3% painted) | 4.66 % | 3.32 | default-button,cancel-button,action-button-order | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.80 | default-button,cancel-button,action-button-order | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.80 | default-button,cancel-button,action-button-order | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.5% painted) | 5.41 % | 4.89 | default-button,cancel-button,action-button-order | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (4.1% painted) | 7.08 % | 3.88 | default-button,cancel-button,action-button-order | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (4.1% painted) | 7.08 % | 3.88 | default-button,cancel-button,action-button-order | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (4.2% painted) | 7.19 % | 4.01 | default-button,cancel-button,action-button-order | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.46 % | 2.95 | default-button,cancel-button,action-button-order | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.46 % | 2.95 | default-button,cancel-button,action-button-order | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.4% painted) | 3.52 % | 3.05 | default-button,cancel-button,action-button-order | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (5.0% painted) | 26.01 % | 9.32 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (5.0% painted) | 26.01 % | 9.32 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (4.9% painted) | 26.00 % | 9.27 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (8.9% painted) | 11.60 % | 6.05 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (8.9% painted) | 11.60 % | 6.05 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.8% painted) | pass (5.4% painted) | 8.29 % | 5.43 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.2% painted) | 10.93 % | 11.45 |  | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (14.4% painted) | 21.82 % | 24.10 |  | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (13.1% painted) | 18.84 % | 20.08 |  | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.2% painted) | 10.93 % | 11.45 |  | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (14.8% painted) | 22.00 % | 23.70 |  | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (15.0% painted) | 22.03 % | 23.85 |  | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.9% painted) | 6.41 % | 3.49 |  | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.9% painted) | 6.41 % | 3.49 |  | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (2.9% painted) | 6.56 % | 3.68 |  | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.4% painted) | 10.19 % | 4.75 | cancel-button,action-button-order | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.5% painted) | 10.24 % | 4.88 | cancel-button,action-button-order | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (4.5% painted) | 10.27 % | 4.93 | cancel-button,action-button-order | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (4.8% painted) | 41.02 % | 49.93 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (4.8% painted) | 41.02 % | 49.93 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (4.9% painted) | 41.18 % | 50.11 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.41 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.44 % | 4.98 | default-button,cancel-button,action-button-order | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (4.9% painted) | 11.88 % | 9.77 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (6.8% painted) | 11.29 % | 11.54 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.41 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/options.tab-general.png |
| `options.tab-replace` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 7.54 % | 5.10 | default-button,cancel-button,action-button-order | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (7.3% painted) | 16.29 % | 8.59 | action-button-order | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (7.3% painted) | 16.29 % | 8.59 | action-button-order | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (7.7% painted) | 15.52 % | 8.21 | action-button-order | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (7.3% painted) | 16.29 % | 8.59 | action-button-order | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (4.2% painted) | 8.20 % | 4.64 | action-button-order | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (7.4% painted) | 16.42 % | 8.77 | action-button-order | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (15.9% painted) | 17.45 % | 14.96 |  | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (15.9% painted) | 17.45 % | 14.96 |  | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (15.9% painted) | 17.45 % | 14.96 |  | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (9.4% painted) | pass (10.4% painted) | 10.00 % | 10.67 |  | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.2% painted) | pass (16.7% painted) | 18.34 % | 16.20 |  | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **semantic-mismatch** | pass (1.7% painted) | pass (1.9% painted) | 1.89 % | 1.89 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **semantic-mismatch** | pass (1.8% painted) | pass (1.9% painted) | 1.93 % | 1.91 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.3% painted) | 6.94 % | 5.20 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.07 % | 5.35 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.08 % | 5.38 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.71 % | 7.43 | default-button | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.73 % | 7.45 | default-button | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.76 % | 7.48 | default-button | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.5% painted) | 8.81 % | 5.78 | default-button,cancel-button,action-button-order | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (5.5% painted) | 8.85 % | 5.83 | default-button,cancel-button,action-button-order | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.5% painted) | 8.81 % | 5.78 | default-button,cancel-button,action-button-order | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (26.1% painted) | 18.49 % | 11.28 |  | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (26.3% painted) | 18.68 % | 11.51 |  | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (26.3% painted) | 18.70 % | 11.52 |  | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (32.9% painted) | pass (10.5% painted) | 26.30 % | 10.54 | focus | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (3.2% painted) | 6.67 % | 3.58 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (3.6% painted) | 7.00 % | 4.15 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.1% painted) | pass (3.5% painted) | 8.00 % | 4.28 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (8.4% painted) | 13.62 % | 9.41 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (8.5% painted) | 13.75 % | 9.61 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (6.5% painted) | 9.86 % | 7.41 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **genuine-visual-mismatch** | pass (3.2% painted) | pass (3.2% painted) | 3.32 % | 2.85 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (5.4% painted) | 7.19 % | 5.35 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (8.4% painted) | 13.62 % | 9.41 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (8.9% painted) | 14.41 % | 10.14 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (5.6% painted) | 13.99 % | 6.67 | default-button,cancel-button,action-button-order | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (5.7% painted) | 14.02 % | 6.71 | default-button,cancel-button,action-button-order | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (5.7% painted) | 14.13 % | 6.85 | default-button,cancel-button,action-button-order | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.4% painted) | 5.39 % | 5.47 | default-button,cancel-button | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.50 % | 5.64 | default-button,cancel-button | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.51 % | 5.66 | default-button,cancel-button | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 | default-button,cancel-button,action-button-order | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 | default-button,cancel-button,action-button-order | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 | default-button,cancel-button,action-button-order | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.23 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.23 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.0% painted) | 4.31 % | 3.30 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.2% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `cell-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `cell-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cell-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `comment-list.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-reply.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `comment-reply.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `comment-reply.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.2% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.2% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.3% painted) |  |  |  |  |
| `draw-table-dimension.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `draw-table-dimension.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `draw-table-dimension.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `field-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `field-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `field-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `hyperlink.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `hyperlink.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `hyperlink.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `link-bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `link-bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `link-bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.4% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.4% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.4% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.4% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (8.8% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (8.8% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (8.9% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.3% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.3% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.3% painted) |  |  |  |  |
| `page-number-format.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `page-number-format.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `page-number-format.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `proofing-language.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `proofing-language.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `proofing-language.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `quick-part-name.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `quick-part-name.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `quick-part-name.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `quick-part.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `quick-part.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `quick-part.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `save-compatibility-warning.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `save-compatibility-warning.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `save-compatibility-warning.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `screen-tip.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `screen-tip.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `screen-tip.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `set-as-default-confirmation.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `set-as-default-confirmation.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `set-as-default-confirmation.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (7.0% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (7.2% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (7.1% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `table-text-conversion.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.4% painted) |  |  |  |  |
| `table-text-conversion.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.4% painted) |  |  |  |  |
| `table-text-conversion.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.4% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.8% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
