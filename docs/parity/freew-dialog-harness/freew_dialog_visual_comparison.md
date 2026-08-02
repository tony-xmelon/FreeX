# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **475**. Captured WPF: **187**. Captured Avalonia: **279**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.54 % | 16.78 |  | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (9.8% painted) | 13.54 % | 16.78 |  | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.9% painted) | 1.76 % | 2.06 |  | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 |  | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 |  | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.8% painted) | 7.61 % | 17.08 |  | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **pass** | pass (2.6% painted) | pass (1.9% painted) | 2.54 % | 2.77 |  | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (10.3% painted) | 13.54 % | 11.51 |  | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (10.1% painted) | pass (8.8% painted) | 16.15 % | 13.84 | action-button-order | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.4% painted) | 9.47 % | 7.98 | action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **pass** | pass (1.2% painted) | pass (1.0% painted) | 1.88 % | 1.77 |  | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.2% painted) | pass (10.8% painted) | 20.89 % | 18.10 |  | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (2.0% painted) | 3.00 % | 3.29 |  | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (7.8% painted) | 13.91 % | 10.68 | action-button-order | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (5.5% painted) | 15.56 % | 12.64 | action-button-order | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.8% painted) | 4.24 % | 4.20 | action-button-order | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.6% painted) | 3.12 % | 1.91 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (6.8% painted) | 11.52 % | 6.21 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (6.8% painted) | 11.52 % | 6.21 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (6.8% painted) | 11.52 % | 6.21 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.tab-borders.png |
| `borders-and-shading.tab-page-border` | captured/captured | **genuine-visual-mismatch** | pass (16.1% painted) | pass (6.8% painted) | 15.16 % | 6.84 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.tab-page-border.png |
| `borders-and-shading.tab-shading` | captured/captured | **genuine-visual-mismatch** | pass (9.5% painted) | pass (4.6% painted) | 8.20 % | 3.85 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.tab-shading.png |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (6.9% painted) | 11.64 % | 6.37 | default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.5% painted) | 6.07 % | 4.83 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.5% painted) | 6.09 % | 4.85 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.4% painted) | 6.09 % | 4.88 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `cell-shading.initial` | captured/captured | **pass** | pass (2.4% painted) | pass (2.6% painted) | 1.97 % | 1.50 |  | heatmaps/cell-shading.initial.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.1% painted) | 3.22 % | 2.68 |  | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.5% painted) | 3.66 % | 3.26 |  | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.34 % | 2.84 |  | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.21 % | 2.70 |  | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.2% painted) | 3.21 % | 2.70 |  | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.3% painted) | 3.32 % | 2.85 |  | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **pass** | pass (1.8% painted) | pass (1.8% painted) | 1.41 % | 1.63 |  | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **pass** | pass (1.9% painted) | pass (2.0% painted) | 1.70 % | 2.04 |  | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.8% painted) | 1.54 % | 1.80 |  | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.1% painted) | 5.97 % | 3.47 | default-button,cancel-button,action-button-order | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (3.1% painted) | 5.97 % | 3.47 | default-button,cancel-button,action-button-order | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.5% painted) | pass (3.2% painted) | 6.12 % | 3.67 | default-button,cancel-button,action-button-order | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (3.2% painted) | 4.84 % | 4.24 | focus | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (3.2% painted) | 4.87 % | 4.24 | focus | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (4.7% painted) | 7.25 % | 7.46 | focus | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (3.2% painted) | 5.09 % | 4.27 | focus | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.9% painted) | 9.59 % | 6.08 | default-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.39 | default-button,cancel-button,action-button-order | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.5% painted) | 4.53 % | 3.39 | default-button,cancel-button,action-button-order | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (2.6% painted) | 4.67 % | 3.57 | default-button,cancel-button,action-button-order | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.14 | default-button,cancel-button | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.8% painted) | 13.24 % | 11.15 | default-button,cancel-button | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.65 % | 4.05 | default-button,cancel-button | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.65 % | 4.05 | default-button,cancel-button | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (5.3% painted) | 7.69 % | 4.13 | default-button,cancel-button | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 |  | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 |  | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.2% painted) | 6.07 % | 4.93 |  | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.6% painted) | 5.33 % | 4.23 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.5% painted) | 5.80 % | 4.06 | default-button,cancel-button,action-button-order | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.5% painted) | 5.80 % | 4.06 | default-button,cancel-button,action-button-order | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (3.6% painted) | 5.85 % | 4.13 | default-button,cancel-button,action-button-order | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (7.3% painted) | 15.18 % | 8.09 |  | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (7.1% painted) | 15.08 % | 8.09 |  | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.8% painted) | pass (7.3% painted) | 15.27 % | 8.26 |  | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (13.0% painted) | 7.88 % | 7.50 |  | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.5% painted) | pass (13.0% painted) | 7.98 % | 7.65 |  | heatmaps/font.populated.png |
| `font.tab-advanced` | captured/captured | **genuine-visual-mismatch** | pass (17.8% painted) | pass (17.6% painted) | 8.16 % | 7.00 |  | heatmaps/font.tab-advanced.png |
| `font.tab-font` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (13.0% painted) | 7.89 % | 7.52 |  | heatmaps/font.tab-font.png |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (13.1% painted) | 8.15 % | 7.90 |  | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.9% painted) | 7.28 % | 5.25 |  | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.9% painted) | 7.45 % | 5.39 |  | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.0% painted) | pass (15.3% painted) | 7.62 % | 5.74 |  | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.40 | default-button,cancel-button,action-button-order | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.7% painted) | 5.25 % | 4.40 | default-button,cancel-button,action-button-order | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.7% painted) | 5.37 % | 4.57 | default-button,cancel-button,action-button-order | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.7% painted) | pass (8.1% painted) | 13.69 % | 19.87 |  | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **pass** | pass (2.4% painted) | pass (2.4% painted) | 1.28 % | 1.28 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **pass** | pass (2.5% painted) | pass (2.5% painted) | 1.37 % | 1.40 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.70 |  | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (3.1% painted) | 5.84 % | 4.70 |  | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (3.1% painted) | 5.99 % | 4.90 |  | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (3.3% painted) | 4.53 % | 3.16 |  | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (3.5% painted) | 4.83 % | 3.57 |  | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (3.3% painted) | 4.66 % | 3.32 |  | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.80 |  | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.4% painted) | 5.33 % | 4.80 |  | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.5% painted) | 5.41 % | 4.89 |  | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (4.1% painted) | 7.08 % | 3.88 |  | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (4.1% painted) | 7.08 % | 3.88 |  | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (4.2% painted) | 7.19 % | 4.01 |  | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.46 % | 2.95 |  | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.4% painted) | 3.46 % | 2.95 |  | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.4% painted) | 3.52 % | 3.05 |  | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.43 % | 4.94 | action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.43 % | 4.94 | action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (21.2% painted) | 6.41 % | 4.91 | action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (8.9% painted) | 11.60 % | 6.05 |  | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (8.9% painted) | 11.60 % | 6.05 |  | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.8% painted) | pass (5.4% painted) | 8.29 % | 5.43 |  | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (7.2% painted) | 9.10 % | 9.57 |  | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (14.0% painted) | 19.86 % | 22.03 |  | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (12.5% painted) | 17.57 % | 19.94 |  | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (7.2% painted) | 9.10 % | 9.57 |  | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (13.2% painted) | 19.90 % | 23.08 |  | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (13.2% painted) | 19.57 % | 22.37 |  | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.9% painted) | 6.41 % | 3.49 | default-button,cancel-button,action-button-order | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (2.9% painted) | 6.41 % | 3.49 | default-button,cancel-button,action-button-order | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (2.9% painted) | 6.56 % | 3.68 | default-button,cancel-button,action-button-order | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 6.45 % | 3.85 |  | heatmaps/manage-styles.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.4% painted) | 10.19 % | 4.75 |  | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.5% painted) | 10.24 % | 4.88 |  | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (4.5% painted) | 10.27 % | 4.93 |  | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **pass** | pass (24.2% painted) | pass (24.0% painted) | 2.77 % | 2.45 |  | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **pass** | pass (24.2% painted) | pass (24.0% painted) | 2.77 % | 2.45 |  | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **pass** | pass (24.2% painted) | pass (24.1% painted) | 2.92 % | 2.65 |  | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.41 % | 4.94 |  | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.44 % | 4.98 |  | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (4.9% painted) | 11.88 % | 9.77 | action-button-order | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (6.8% painted) | 11.29 % | 11.54 |  | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.3% painted) | 7.41 % | 4.94 |  | heatmaps/options.tab-general.png |
| `options.tab-replace` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 7.54 % | 5.10 |  | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (12.9% painted) | 13.38 % | 7.83 |  | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (12.9% painted) | 13.38 % | 7.83 |  | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (11.2% painted) | 13.89 % | 7.19 |  | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (12.9% painted) | 13.38 % | 7.83 |  | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (6.2% painted) | 5.14 % | 3.54 |  | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (13.0% painted) | 13.49 % | 7.96 |  | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.19 % | 9.36 |  | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.19 % | 9.36 |  | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.19 % | 9.36 |  | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (9.2% painted) | pass (8.7% painted) | 8.25 % | 10.76 |  | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.3% painted) | pass (14.2% painted) | 8.92 % | 10.18 |  | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **pass** | pass (1.7% painted) | pass (1.9% painted) | 1.89 % | 1.89 |  | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **pass** | pass (1.8% painted) | pass (1.9% painted) | 1.93 % | 1.91 |  | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (14.2% painted) | 8.85 % | 9.11 |  | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.3% painted) | 6.94 % | 5.20 | focus | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.07 % | 5.35 | focus | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.4% painted) | 7.08 % | 5.38 | focus | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.71 % | 7.43 | default-button | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.73 % | 7.45 | default-button | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.3% painted) | 10.76 % | 7.48 | default-button | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.5% painted) | 8.81 % | 5.78 |  | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (5.5% painted) | 8.85 % | 5.83 |  | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.5% painted) | 8.81 % | 5.78 |  | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (26.4% painted) | 16.06 % | 10.37 |  | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (26.0% painted) | pass (26.7% painted) | 16.27 % | 10.58 |  | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (26.4% painted) | 16.06 % | 10.37 |  | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **pass** | pass (32.9% painted) | pass (33.0% painted) | 2.09 % | 1.72 |  | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (3.2% painted) | 6.67 % | 3.58 | focus | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (3.6% painted) | 7.00 % | 4.15 | focus | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.1% painted) | pass (3.5% painted) | 8.00 % | 4.28 | focus | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 |  | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 |  | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (2.7% painted) | 10.64 % | 4.39 |  | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.6% painted) | 9.13 % | 6.67 |  | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.6% painted) | 9.13 % | 6.67 |  | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (7.4% painted) | 6.61 % | 4.81 |  | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **pass** | pass (3.3% painted) | pass (3.0% painted) | 2.65 % | 2.11 |  | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (6.6% painted) | pass (6.3% painted) | 4.48 % | 3.76 |  | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.6% painted) | 9.13 % | 6.67 |  | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.7% painted) | 9.24 % | 6.81 |  | heatmaps/table-properties.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (9.7% painted) | 4.37 % | 2.63 |  | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (9.7% painted) | 4.40 % | 2.66 |  | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (9.8% painted) | 4.49 % | 2.77 |  | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.4% painted) | 5.39 % | 5.47 | default-button,cancel-button | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.50 % | 5.64 | default-button,cancel-button | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.5% painted) | 5.51 % | 5.66 | default-button,cancel-button | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 |  | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 |  | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.1% painted) | 3.17 % | 2.87 |  | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.23 | focus | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.26 % | 3.23 | focus | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (2.0% painted) | 4.31 % | 3.30 | focus | heatmaps/zoom.validation-error.png |
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
| `insert-chart.tab-add-row` | avalonia-extension | **avalonia-extension** |  | pass (21.2% painted) |  |  |  |  |
| `insert-chart.tab-remove-row` | avalonia-extension | **avalonia-extension** |  | pass (21.2% painted) |  |  |  |  |
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
