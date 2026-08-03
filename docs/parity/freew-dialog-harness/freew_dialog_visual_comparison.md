# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **478**. Captured WPF: **190**. Captured Avalonia: **288**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (7.6% painted) | 11.40 % | 14.07 |  | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.4% painted) | pass (7.6% painted) | 11.40 % | 14.07 |  | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.3% painted) | 1.20 % | 0.90 |  | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **pass** | pass (0.9% painted) | pass (0.9% painted) | 0.60 % | 0.83 |  | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **pass** | pass (0.9% painted) | pass (0.9% painted) | 0.60 % | 0.83 |  | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **pass** | pass (0.9% painted) | pass (0.9% painted) | 0.60 % | 0.83 |  | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **pass** | pass (2.6% painted) | pass (1.9% painted) | 2.53 % | 2.77 |  | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (10.3% painted) | 13.54 % | 11.51 |  | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (9.2% painted) | pass (7.9% painted) | 11.79 % | 9.68 |  | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (3.6% painted) | 8.99 % | 7.91 | action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **pass** | pass (1.2% painted) | pass (1.0% painted) | 1.88 % | 1.77 |  | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (12.4% painted) | 16.85 % | 14.20 |  | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **pass** | pass (1.8% painted) | pass (1.5% painted) | 1.82 % | 2.03 |  | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (7.0% painted) | 8.59 % | 7.26 |  | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (11.0% painted) | 9.18 % | 7.50 |  | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **pass** | pass (2.5% painted) | pass (2.1% painted) | 2.73 % | 2.63 |  | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **pass** | pass (2.8% painted) | pass (2.6% painted) | 2.89 % | 1.65 |  | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **pass** | pass (6.0% painted) | pass (6.2% painted) | 2.74 % | 2.15 |  | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **pass** | pass (6.0% painted) | pass (6.2% painted) | 2.74 % | 2.15 |  | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (10.3% painted) | 11.28 % | 6.60 |  | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.5% painted) | pass (10.3% painted) | 11.28 % | 6.60 |  | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-page-border` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-shading` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (10.4% painted) | 11.38 % | 6.76 |  | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.4% painted) | 5.99 % | 4.58 |  | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.4% painted) | 6.01 % | 4.60 |  | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.3% painted) | 6.01 % | 4.63 |  | heatmaps/building-blocks-organizer.validation-error.png |
| `cell-shading.initial` | captured/captured | **pass** | pass (2.4% painted) | pass (2.6% painted) | 1.97 % | 1.51 |  | heatmaps/cell-shading.initial.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.8% painted) | 3.05 % | 2.21 |  | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.2% painted) | 3.48 % | 2.80 |  | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 3.17 % | 2.37 |  | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 3.04 % | 2.21 |  | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 3.04 % | 2.21 |  | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.9% painted) | 3.14 % | 2.36 |  | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **pass** | pass (1.8% painted) | pass (1.5% painted) | 1.25 % | 1.24 |  | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **pass** | pass (1.9% painted) | pass (1.7% painted) | 1.54 % | 1.65 |  | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **pass** | pass (1.9% painted) | pass (1.5% painted) | 1.37 % | 1.41 |  | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.2% painted) | 4.55 % | 3.10 |  | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.2% painted) | 4.55 % | 3.10 |  | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.5% painted) | pass (5.2% painted) | 4.68 % | 3.30 |  | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (2.9% painted) | 4.61 % | 3.77 | focus | heatmaps/compare-documents.initial.png |
| `compare-documents.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (2.9% painted) | 4.65 % | 3.78 | focus | heatmaps/compare-documents.populated.png |
| `compare-documents.tab-more` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (4.3% painted) | 6.97 % | 6.95 | focus | heatmaps/compare-documents.tab-more.png |
| `compare-documents.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.1% painted) | pass (2.8% painted) | 4.85 % | 3.79 | focus | heatmaps/compare-documents.validation-error.png |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.8% painted) | 9.51 % | 5.78 | default-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.8% painted) | 9.51 % | 5.78 | default-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (4.8% painted) | 9.51 % | 5.78 | default-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.3% painted) | 4.36 % | 3.22 |  | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (2.3% painted) | 4.36 % | 3.22 |  | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (2.3% painted) | 4.49 % | 3.40 |  | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 9.64 % | 7.46 |  | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 9.64 % | 7.46 |  | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 9.64 % | 7.46 |  | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.9% painted) | 3.09 % | 2.16 |  | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.9% painted) | 3.09 % | 2.16 |  | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (2.9% painted) | 3.16 % | 2.27 |  | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.0% painted) | 5.98 % | 4.73 |  | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.0% painted) | 5.98 % | 4.73 |  | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (6.0% painted) | 5.98 % | 4.73 |  | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.4% painted) | 5.31 % | 4.46 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.4% painted) | 5.31 % | 4.46 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.4% painted) | 5.31 % | 4.46 | default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.7% painted) | 5.08 % | 3.92 |  | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.7% painted) | 5.08 % | 3.92 |  | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.7% painted) | 5.13 % | 3.99 |  | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (8.1% painted) | 7.23 % | 4.52 |  | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (8.1% painted) | 7.28 % | 4.58 |  | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.8% painted) | pass (8.2% painted) | 7.34 % | 4.67 |  | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.0% painted) | pass (12.7% painted) | 8.46 % | 8.38 |  | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.0% painted) | pass (12.8% painted) | 8.55 % | 8.50 |  | heatmaps/font.populated.png |
| `font.tab-advanced` | captured/captured | **genuine-visual-mismatch** | pass (17.8% painted) | pass (17.6% painted) | 8.15 % | 7.00 |  | heatmaps/font.tab-advanced.png |
| `font.tab-font` | captured/captured | **genuine-visual-mismatch** | pass (12.0% painted) | pass (12.7% painted) | 8.46 % | 8.38 |  | heatmaps/font.tab-font.png |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.1% painted) | pass (12.9% painted) | 8.71 % | 8.74 |  | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.5% painted) | 6.59 % | 4.27 |  | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (14.5% painted) | 6.75 % | 4.39 |  | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (15.0% painted) | pass (14.9% painted) | 6.94 % | 4.75 |  | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.4% painted) | 5.09 % | 4.21 |  | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (2.4% painted) | 5.09 % | 4.21 |  | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (2.5% painted) | 5.20 % | 4.38 |  | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.7% painted) | pass (10.0% painted) | 12.10 % | 15.36 |  | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **pass** | pass (2.4% painted) | pass (2.3% painted) | 1.12 % | 1.10 |  | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **pass** | pass (2.5% painted) | pass (2.3% painted) | 1.20 % | 1.22 |  | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.7% painted) | 5.53 % | 4.10 |  | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.7% painted) | 5.53 % | 4.10 |  | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.7% painted) | 5.66 % | 4.30 |  | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (4.6% painted) | 3.19 % | 2.56 |  | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (4.9% painted) | 3.49 % | 2.97 |  | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (4.7% painted) | 3.30 % | 2.72 |  | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.0% painted) | 5.11 % | 4.09 |  | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.0% painted) | 5.11 % | 4.09 |  | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (3.0% painted) | 5.18 % | 4.18 |  | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (7.7% painted) | 4.04 % | 2.89 |  | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (7.7% painted) | 4.04 % | 2.89 |  | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (7.7% painted) | 4.14 % | 3.03 |  | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.1% painted) | 3.28 % | 2.44 |  | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (2.1% painted) | 3.28 % | 2.44 |  | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (2.1% painted) | 3.35 % | 2.54 |  | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (20.7% painted) | 6.17 % | 4.58 | action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (20.7% painted) | 6.17 % | 4.58 | action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.1% painted) | pass (20.7% painted) | 6.15 % | 4.54 | action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (10.9% painted) | 9.69 % | 5.12 |  | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.3% painted) | pass (10.9% painted) | 9.69 % | 5.12 |  | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.8% painted) | pass (7.4% painted) | 6.35 % | 4.50 |  | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (7.4% painted) | 8.98 % | 9.57 |  | heatmaps/legal-notices.initial.png |
| `legal-notices.tab-legal-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (13.5% painted) | 17.79 % | 18.54 |  | heatmaps/legal-notices.tab-legal-notices.png |
| `legal-notices.tab-privacy-notice` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (12.1% painted) | 16.46 % | 18.48 |  | heatmaps/legal-notices.tab-privacy-notice.png |
| `legal-notices.tab-project-license` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (7.4% painted) | 8.98 % | 9.57 |  | heatmaps/legal-notices.tab-project-license.png |
| `legal-notices.tab-third-party-license-texts` | captured/captured | **genuine-visual-mismatch** | pass (14.5% painted) | pass (12.8% painted) | 17.97 % | 19.97 |  | heatmaps/legal-notices.tab-third-party-license-texts.png |
| `legal-notices.tab-third-party-notices` | captured/captured | **genuine-visual-mismatch** | pass (14.9% painted) | pass (12.9% painted) | 17.61 % | 19.13 |  | heatmaps/legal-notices.tab-third-party-notices.png |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (4.8% painted) | 6.39 % | 3.31 |  | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (4.8% painted) | 6.39 % | 3.31 |  | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (4.9% painted) | 6.53 % | 3.51 |  | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 5.48 % | 3.54 |  | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 5.48 % | 3.54 |  | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (7.7% painted) | 5.48 % | 3.54 |  | heatmaps/manage-styles.validation-error.png |
| `manual-hyphenation.initial` | captured/captured | **pass** | pass (5.6% painted) | pass (5.7% painted) | 2.50 % | 1.86 |  | heatmaps/manual-hyphenation.initial.png |
| `manual-hyphenation.populated` | captured/captured | **pass** | pass (5.6% painted) | pass (5.7% painted) | 2.52 % | 1.85 |  | heatmaps/manual-hyphenation.populated.png |
| `manual-hyphenation.validation-error` | captured/captured | **pass** | pass (5.6% painted) | pass (5.7% painted) | 2.52 % | 1.85 |  | heatmaps/manual-hyphenation.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.7% painted) | 10.45 % | 4.55 |  | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.4% painted) | pass (4.8% painted) | 10.48 % | 4.67 |  | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (4.7% painted) | 10.52 % | 4.73 |  | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **pass** | pass (24.2% painted) | pass (24.0% painted) | 2.77 % | 2.45 |  | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **pass** | pass (24.2% painted) | pass (24.0% painted) | 2.77 % | 2.45 |  | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **pass** | pass (24.2% painted) | pass (24.1% painted) | 2.92 % | 2.65 |  | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 6.36 % | 4.41 |  | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 6.38 % | 4.44 |  | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (10.0% painted) | 11.88 % | 10.06 |  | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (5.7% painted) | 10.08 % | 9.49 |  | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 6.36 % | 4.41 |  | heatmaps/options.tab-general.png |
| `options.tab-replace` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (5.4% painted) | 6.48 % | 4.58 |  | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (16.4% painted) | pass (15.5% painted) | 15.25 % | 8.79 |  | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (16.4% painted) | pass (15.5% painted) | 15.25 % | 8.79 |  | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (11.4% painted) | pass (10.8% painted) | 6.72 % | 4.96 |  | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (16.4% painted) | pass (15.5% painted) | 15.25 % | 8.79 |  | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.5% painted) | pass (5.9% painted) | 4.69 % | 3.39 |  | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (16.5% painted) | pass (15.6% painted) | 15.35 % | 8.93 |  | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.15 % | 9.39 |  | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.15 % | 9.39 |  | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.1% painted) | pass (13.4% painted) | 8.15 % | 9.39 |  | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (9.2% painted) | pass (8.7% painted) | 8.19 % | 10.77 |  | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.3% painted) | pass (14.2% painted) | 8.89 % | 10.20 |  | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | captured/captured | **pass** | pass (1.7% painted) | pass (1.5% painted) | 1.71 % | 1.74 |  | heatmaps/password-prompt.initial.png |
| `password-prompt.populated` | captured/captured | **pass** | pass (1.8% painted) | pass (1.6% painted) | 1.75 % | 1.75 |  | heatmaps/password-prompt.populated.png |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (13.7% painted) | 8.02 % | 8.61 |  | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (13.7% painted) | 8.02 % | 8.61 |  | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (13.7% painted) | 8.02 % | 8.61 |  | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.9% painted) | 6.65 % | 4.33 | focus | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.0% painted) | 6.76 % | 4.48 | focus | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (3.0% painted) | 6.78 % | 4.51 | focus | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.0% painted) | 10.57 % | 7.31 | default-button | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.0% painted) | 10.58 % | 7.32 | default-button | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (5.0% painted) | 10.61 % | 7.35 | default-button | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | captured/captured | **pass** | pass (17.5% painted) | pass (17.5% painted) | 0.00 % | 0.06 |  | heatmaps/screen-clip-overlay.open.png |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.3% painted) | 8.73 % | 5.86 |  | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (5.3% painted) | 8.78 % | 5.91 |  | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (5.3% painted) | 8.73 % | 5.86 |  | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.6% painted) | pass (25.3% painted) | 3.78 % | 4.15 |  | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.9% painted) | pass (25.6% painted) | 3.92 % | 4.43 |  | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.6% painted) | pass (25.3% painted) | 3.78 % | 4.15 |  | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | captured/captured | **pass** | pass (32.9% painted) | pass (33.0% painted) | 2.03 % | 1.71 |  | heatmaps/symbol-picker.initial.png |
| `table-formula.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (5.9% painted) | 4.43 % | 3.29 | focus | heatmaps/table-formula.initial.png |
| `table-formula.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.0% painted) | pass (6.3% painted) | 4.81 % | 3.86 | focus | heatmaps/table-formula.populated.png |
| `table-formula.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.1% painted) | pass (6.1% painted) | 5.75 % | 3.97 | focus | heatmaps/table-formula.validation-error.png |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (8.8% painted) | 11.34 % | 4.50 |  | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (8.8% painted) | 11.34 % | 4.50 |  | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (8.8% painted) | 11.34 % | 4.50 |  | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.4% painted) | 9.00 % | 6.78 |  | heatmaps/table-properties.initial.png |
| `table-properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.4% painted) | 9.00 % | 6.78 |  | heatmaps/table-properties.populated.png |
| `table-properties.tab-cell` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (7.2% painted) | 6.52 % | 4.87 |  | heatmaps/table-properties.tab-cell.png |
| `table-properties.tab-column` | captured/captured | **pass** | pass (3.3% painted) | pass (2.9% painted) | 2.62 % | 2.13 |  | heatmaps/table-properties.tab-column.png |
| `table-properties.tab-row` | captured/captured | **genuine-visual-mismatch** | pass (6.6% painted) | pass (6.1% painted) | 4.37 % | 3.80 |  | heatmaps/table-properties.tab-row.png |
| `table-properties.tab-table` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.4% painted) | 9.00 % | 6.78 |  | heatmaps/table-properties.tab-table.png |
| `table-properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (10.4% painted) | 9.10 % | 6.92 |  | heatmaps/table-properties.validation-error.png |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (9.6% painted) | 4.29 % | 2.61 |  | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (9.6% painted) | 4.32 % | 2.64 |  | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (9.7% painted) | 4.39 % | 2.74 |  | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.2% painted) | 5.28 % | 5.04 | default-button,cancel-button | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.3% painted) | 5.38 % | 5.21 | default-button,cancel-button | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (4.3% painted) | 5.39 % | 5.23 | default-button,cancel-button | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.0% painted) | 3.13 % | 2.85 |  | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.0% painted) | 3.13 % | 2.85 |  | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.0% painted) | 3.13 % | 2.85 |  | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.8% painted) | 4.20 % | 3.16 | focus | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.8% painted) | 4.20 % | 3.16 | focus | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | state-not-applicable | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.9% painted) | 4.24 % | 3.23 | focus | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.8% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.7% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.8% painted) |  |  |  |  |
| `caption.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.2% painted) |  |  |  |  |
| `caption.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.2% painted) |  |  |  |  |
| `caption.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.3% painted) |  |  |  |  |
| `cell-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `cell-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cell-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `character-formatting-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.8% painted) |  |  |  |  |
| `character-formatting-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.6% painted) |  |  |  |  |
| `character-formatting-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.8% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.7% painted) |  |  |  |  |
| `comment-list.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-list.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.8% painted) |  |  |  |  |
| `comment-reply.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `comment-reply.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `comment-reply.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.1% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.1% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.2% painted) |  |  |  |  |
| `draw-table-dimension.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `draw-table-dimension.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `draw-table-dimension.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `field-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.8% painted) |  |  |  |  |
| `field-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.8% painted) |  |  |  |  |
| `field-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.8% painted) |  |  |  |  |
| `header-footer-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `header-footer-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `header-footer-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `hyperlink.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.3% painted) |  |  |  |  |
| `hyperlink.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `hyperlink.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.3% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `insert-chart.tab-add-row` | avalonia-extension | **avalonia-extension** |  | pass (20.7% painted) |  |  |  |  |
| `insert-chart.tab-remove-row` | avalonia-extension | **avalonia-extension** |  | pass (20.7% painted) |  |  |  |  |
| `link-bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `link-bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `link-bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.3% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.3% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (6.3% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.5% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.4% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (15.4% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (15.4% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (15.4% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.4% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.5% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.5% painted) |  |  |  |  |
| `page-number-format.initial` | avalonia-extension | **avalonia-extension** |  | pass (13.3% painted) |  |  |  |  |
| `page-number-format.populated` | avalonia-extension | **avalonia-extension** |  | pass (13.3% painted) |  |  |  |  |
| `page-number-format.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (13.3% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.7% painted) |  |  |  |  |
| `proofing-language.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `proofing-language.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `proofing-language.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.6% painted) |  |  |  |  |
| `quick-part-name.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `quick-part-name.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `quick-part-name.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `quick-part.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `quick-part.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `quick-part.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `save-compatibility-warning.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `save-compatibility-warning.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `save-compatibility-warning.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `screen-tip.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `screen-tip.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `screen-tip.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.7% painted) |  |  |  |  |
| `set-as-default-confirmation.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `set-as-default-confirmation.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `set-as-default-confirmation.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.6% painted) |  |  |  |  |
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (6.0% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.0% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.9% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.4% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.8% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.8% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.8% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (7.3% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (7.5% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (7.4% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `table-text-conversion.initial` | avalonia-extension | **avalonia-extension** |  | pass (5.3% painted) |  |  |  |  |
| `table-text-conversion.populated` | avalonia-extension | **avalonia-extension** |  | pass (5.3% painted) |  |  |  |  |
| `table-text-conversion.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (5.3% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (6.7% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
