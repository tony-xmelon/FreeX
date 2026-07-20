# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **457**. Captured WPF: **186**. Captured Avalonia: **271**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.49 % | 16.73 |  | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.49 % | 16.73 |  | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.9% painted) | 1.71 % | 2.00 |  | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.13 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.13 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.13 | default-button,cancel-button,action-button-order | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (30.6% painted) | 41.64 % | 79.02 | action-button-order | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (30.4% painted) | 47.29 % | 80.93 | action-button-order | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (29.5% painted) | 46.17 % | 80.77 | action-button-order | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (32.2% painted) | 45.16 % | 80.29 | action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **genuine-visual-mismatch** | pass (1.2% painted) | pass (29.5% painted) | 39.57 % | 77.40 | action-button-order | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (30.8% painted) | 49.22 % | 82.59 | action-button-order | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (29.5% painted) | 40.07 % | 77.86 | action-button-order | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (8.5% painted) | 14.14 % | 11.67 |  | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (30.2% painted) | 47.46 % | 80.61 | action-button-order | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (30.2% painted) | 41.18 % | 78.59 | action-button-order | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (29.8% painted) | 29.58 % | 4.97 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (29.8% painted) | 29.58 % | 4.97 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (29.8% painted) | 29.58 % | 4.97 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (4.1% painted) | 16.28 % | 8.69 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (4.1% painted) | 16.28 % | 8.69 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-page-border` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-shading` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (4.2% painted) | 16.40 % | 8.85 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (18.7% painted) | 21.94 % | 6.58 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (18.7% painted) | 21.96 % | 6.60 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (18.6% painted) | 21.96 % | 6.63 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.1% painted) | 3.22 % | 2.64 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.5% painted) | 3.65 % | 3.22 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.34 % | 2.80 | default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.20 % | 2.66 | default-button,cancel-button,action-button-order | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.20 % | 2.66 | default-button,cancel-button,action-button-order | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.3% painted) | 3.32 % | 2.80 | default-button,cancel-button,action-button-order | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **semantic-mismatch** | pass (1.8% painted) | pass (1.8% painted) | 1.41 % | 1.58 | default-button,cancel-button,action-button-order | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **semantic-mismatch** | pass (1.9% painted) | pass (2.0% painted) | 1.70 % | 1.99 | default-button,cancel-button,action-button-order | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **semantic-mismatch** | pass (1.9% painted) | pass (1.8% painted) | 1.54 % | 1.75 | default-button,cancel-button,action-button-order | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (2.2% painted) | 5.90 % | 3.43 | action-button-order | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (2.2% painted) | 5.90 % | 3.43 | action-button-order | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.5% painted) | pass (2.3% painted) | 6.04 % | 3.63 | action-button-order | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (4.0% painted) | 5.60 % | 4.45 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (4.0% painted) | 5.63 % | 4.45 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (25.9% painted) | 27.40 % | 10.44 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (4.0% painted) | 5.85 % | 4.48 | focus,default-button,cancel-button,action-button-order | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.7% painted) | 33.78 % | 8.66 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.7% painted) | 33.78 % | 8.66 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.7% painted) | 33.78 % | 8.66 | default-button,cancel-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.33 |  | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.33 |  | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (2.6% painted) | 4.67 % | 3.52 |  | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.15 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.5% painted) | 5.15 % | 3.67 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.5% painted) | 5.15 % | 3.67 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 5.23 % | 3.77 | default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 29.11 % | 7.82 | default-button,cancel-button,action-button-order | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 29.11 % | 7.82 | default-button,cancel-button,action-button-order | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 29.11 % | 7.82 | default-button,cancel-button,action-button-order | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.18 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.18 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.18 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.5% painted) | 4.85 % | 3.87 | action-button-order | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.5% painted) | 4.85 % | 3.87 | action-button-order | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.6% painted) | 4.90 % | 3.93 | action-button-order | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (5.7% painted) | 13.57 % | 7.31 | action-button-order | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (5.5% painted) | 13.47 % | 7.31 | action-button-order | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.6% painted) | pass (5.7% painted) | 13.66 % | 7.47 | action-button-order | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (3.0% painted) | 30.41 % | 50.35 | default-button,cancel-button,action-button-order | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (3.0% painted) | 30.41 % | 50.35 | default-button,cancel-button,action-button-order | heatmaps/font.populated.png |
| `font.tab-advanced` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `font.tab-font` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (3.0% painted) | 30.41 % | 50.35 | default-button,cancel-button,action-button-order | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (3.2% painted) | 17.56 % | 8.03 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (3.2% painted) | 17.56 % | 8.03 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.0% painted) | pass (3.3% painted) | 17.68 % | 8.18 | default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.34 | action-button-order | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.34 | action-button-order | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.7% painted) | 5.37 % | 4.51 | action-button-order | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.7% painted) | pass (45.0% painted) | 49.94 % | 32.01 | action-button-order | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.6% painted) | 4.00 % | 2.45 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.7% painted) | 4.10 % | 2.59 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.66 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.66 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (3.1% painted) | 5.99 % | 4.85 | default-button,cancel-button,action-button-order | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (2.7% painted) | 4.92 % | 3.20 | default-button,cancel-button,action-button-order | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (3.0% painted) | 5.22 % | 3.61 | default-button,cancel-button,action-button-order | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (2.8% painted) | 5.05 % | 3.35 | default-button,cancel-button,action-button-order | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.75 | default-button,cancel-button,action-button-order | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.75 | default-button,cancel-button,action-button-order | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.5% painted) | 5.41 % | 4.85 | default-button,cancel-button,action-button-order | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (2.7% painted) | 8.04 % | 4.04 | default-button,cancel-button,action-button-order | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (2.7% painted) | 8.04 % | 4.04 | default-button,cancel-button,action-button-order | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (2.8% painted) | 8.15 % | 4.17 | default-button,cancel-button,action-button-order | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.45 % | 2.90 | default-button,cancel-button,action-button-order | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.45 % | 2.90 | default-button,cancel-button,action-button-order | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.4% painted) | 3.52 % | 3.01 | default-button,cancel-button,action-button-order | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (3.9% painted) | 25.07 % | 9.13 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (3.9% painted) | 25.07 % | 9.13 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (3.8% painted) | 25.06 % | 9.09 | default-button,cancel-button,action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (23.6% painted) | 27.92 % | 8.95 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (23.6% painted) | 27.92 % | 8.95 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.8% painted) | pass (23.7% painted) | 27.67 % | 7.61 | default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.2% painted) | 10.89 % | 11.39 |  | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (14.4% painted) | 21.78 % | 24.05 |  | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (13.1% painted) | 18.79 % | 20.03 |  | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (9.2% painted) | 10.89 % | 11.39 |  | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (14.8% painted) | 21.96 % | 23.65 |  | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (15.0% painted) | 21.99 % | 23.80 |  | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.0% painted) | 6.38 % | 3.46 |  | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.0% painted) | 6.38 % | 3.46 |  | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (2.1% painted) | 6.53 % | 3.66 |  | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.9% painted) | 65.55 % | 51.75 | action-button-order | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.9% painted) | 65.55 % | 51.75 | action-button-order | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (23.9% painted) | 65.55 % | 51.75 | action-button-order | heatmaps/manage-styles.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (2.5% painted) | 8.29 % | 4.41 | cancel-button,action-button-order | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (2.6% painted) | 8.33 % | 4.53 | cancel-button,action-button-order | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (2.6% painted) | 8.36 % | 4.59 | cancel-button,action-button-order | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (3.2% painted) | 40.07 % | 49.94 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (3.2% painted) | 40.07 % | 49.94 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (3.3% painted) | 40.24 % | 50.12 | default-button,cancel-button,action-button-order | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (4.4% painted) | 7.55 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (4.4% painted) | 7.58 % | 4.98 | default-button,cancel-button,action-button-order | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (4.9% painted) | 11.88 % | 9.72 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (6.8% painted) | 11.29 % | 11.51 | default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (4.4% painted) | 7.55 % | 4.94 | default-button,cancel-button,action-button-order | heatmaps/options.tab-general.png |
| `options.tab-replace` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (4.4% painted) | 7.68 % | 5.10 | default-button,cancel-button,action-button-order | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (4.3% painted) | 16.86 % | 8.66 | action-button-order | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (4.3% painted) | 16.86 % | 8.66 | action-button-order | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (5.6% painted) | 15.37 % | 8.26 | action-button-order | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (4.3% painted) | 16.86 % | 8.66 | action-button-order | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (3.2% painted) | 8.88 % | 4.73 | action-button-order | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.4% painted) | 16.99 % | 8.84 | action-button-order | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (5.2% painted) | 36.25 % | 55.50 | action-button-order | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (5.2% painted) | 36.25 % | 55.50 | action-button-order | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (5.2% painted) | 36.25 % | 55.50 | action-button-order | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (4.1% painted) | 33.71 % | 53.95 | action-button-order | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (5.3% painted) | 36.36 % | 55.67 | action-button-order | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **semantic-mismatch** | pass (1.7% painted) | pass (1.9% painted) | 1.89 % | 1.84 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **semantic-mismatch** | pass (1.8% painted) | pass (1.9% painted) | 1.92 % | 1.86 | focus,default-button,cancel-button,action-button-order | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.7% painted) | 76.64 % | 70.22 | default-button,cancel-button,action-button-order | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.7% painted) | 76.64 % | 70.22 | default-button,cancel-button,action-button-order | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (15.7% painted) | 76.64 % | 70.22 | default-button,cancel-button,action-button-order | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.3% painted) | 6.94 % | 5.15 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.07 % | 5.29 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.08 % | 5.32 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.71 % | 7.32 | default-button,action-button-order | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.73 % | 7.33 | default-button,action-button-order | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.76 % | 7.37 | default-button,action-button-order | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (4.8% painted) | 9.24 % | 5.81 | default-button,cancel-button,action-button-order | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (4.8% painted) | 9.29 % | 5.86 | default-button,cancel-button,action-button-order | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (4.8% painted) | 9.24 % | 5.81 | default-button,cancel-button,action-button-order | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (3.5% painted) | 41.80 % | 51.29 | default-button,cancel-button,action-button-order | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (3.6% painted) | 41.82 % | 51.45 | default-button,cancel-button,action-button-order | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (3.6% painted) | 41.82 % | 51.45 | default-button,cancel-button,action-button-order | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (32.9% painted) | pass (10.5% painted) | 26.30 % | 10.54 | focus | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (2.2% painted) | 6.36 % | 3.50 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (2.6% painted) | 6.75 % | 4.08 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.1% painted) | pass (2.5% painted) | 7.71 % | 4.20 | focus,default-button,cancel-button,action-button-order | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.8% painted) | 10.36 % | 4.31 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.8% painted) | 10.36 % | 4.31 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.8% painted) | 10.36 % | 4.31 | default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (6.1% painted) | 13.78 % | 9.48 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (6.3% painted) | 13.91 % | 9.67 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (5.3% painted) | 9.93 % | 7.42 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **genuine-visual-mismatch** | pass (3.2% painted) | pass (3.2% painted) | 3.28 % | 2.80 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.3% painted) | 7.23 % | 5.36 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (6.1% painted) | 13.78 % | 9.48 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (6.6% painted) | 14.57 % | 10.20 | focus,default-button,cancel-button,action-button-order | heatmaps/table-properties.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (20.6% painted) | 28.92 % | 8.17 | default-button,cancel-button,action-button-order | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (20.6% painted) | 28.94 % | 8.20 | default-button,cancel-button,action-button-order | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (20.7% painted) | 29.02 % | 8.35 | default-button,cancel-button,action-button-order | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.4% painted) | 5.39 % | 5.47 | default-button,cancel-button,action-button-order | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.50 % | 5.64 | default-button,cancel-button,action-button-order | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.51 % | 5.66 | default-button,cancel-button,action-button-order | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.82 | default-button,cancel-button,action-button-order | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.82 | default-button,cancel-button,action-button-order | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.82 | default-button,cancel-button,action-button-order | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.18 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.18 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.0% painted) | 4.31 % | 3.26 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.2% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.1% painted) |  |  |  |  |
| `cell-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `cell-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cell-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (26.7% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (26.7% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (26.7% painted) |  |  |  |  |
| `comment-list.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-reply.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `comment-reply.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `comment-reply.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `draw-table-dimension.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `draw-table-dimension.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `draw-table-dimension.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `field-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `field-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `field-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (32.9% painted) |  |  |  |  |
| `hyperlink.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `hyperlink.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `hyperlink.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `link-bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `link-bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `link-bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.2% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (30.1% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (30.1% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (30.1% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.4% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.5% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `page-number-format.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `page-number-format.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `page-number-format.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.7% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `proofing-language.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `proofing-language.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `proofing-language.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
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
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.9% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.0% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.4% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.6% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.5% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `table-text-conversion.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.9% painted) |  |  |  |  |
| `table-text-conversion.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.9% painted) |  |  |  |  |
| `table-text-conversion.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.9% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.8% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
