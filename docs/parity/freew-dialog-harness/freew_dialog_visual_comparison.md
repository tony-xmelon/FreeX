# FreeW Paired Dialog Visual Comparison

> Target: 96 DPI logical pixels. Semantic checks and nonblank checks are reported separately from image parity.

Inventory scenarios: **436**. Captured WPF: **186**. Captured Avalonia: **250**.

| Scenario | Capture | Classification | WPF content | Avalonia content | Changed ratio | Mean channel delta | Semantic diff | Heatmap |
| --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
| `about.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (0.7% painted) | 17.47 % | 32.33 | focus,default-button,cancel-button,action-button-order | heatmaps/about.initial.png |
| `about.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.1% painted) | pass (0.9% painted) | 17.56 % | 32.46 | focus,default-button,cancel-button,action-button-order | heatmaps/about.populated.png |
| `about.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (1.6% painted) | pass (0.7% painted) | 11.03 % | 23.32 | focus,default-button,cancel-button,action-button-order | heatmaps/about.validation-error.png |
| `accessibility-report.initial` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.5% painted) | 10.29 % | 24.09 | focus,default-button,cancel-button,action-button-order | heatmaps/accessibility-report.initial.png |
| `accessibility-report.populated` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.5% painted) | 10.29 % | 24.09 | focus,default-button,cancel-button,action-button-order | heatmaps/accessibility-report.populated.png |
| `accessibility-report.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (0.9% painted) | pass (0.5% painted) | 10.29 % | 24.09 | focus,default-button,cancel-button,action-button-order | heatmaps/accessibility-report.validation-error.png |
| `backstage-account.open` | captured/captured | **genuine-visual-mismatch** | pass (2.7% painted) | pass (38.2% painted) | 44.67 % | 83.69 | focus,action-button-order | heatmaps/backstage-account.open.png |
| `backstage-export.open` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (36.7% painted) | 49.15 % | 83.33 | focus,action-button-order | heatmaps/backstage-export.open.png |
| `backstage-home.open` | captured/captured | **genuine-visual-mismatch** | pass (10.9% painted) | pass (35.7% painted) | 48.80 % | 84.54 | focus,action-button-order | heatmaps/backstage-home.open.png |
| `backstage-info.open` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (38.8% painted) | 48.17 % | 84.00 | focus,action-button-order | heatmaps/backstage-info.open.png |
| `backstage-new.open` | captured/captured | **genuine-visual-mismatch** | pass (1.2% painted) | pass (35.7% painted) | 42.04 % | 82.49 | focus,action-button-order | heatmaps/backstage-new.open.png |
| `backstage-open.open` | captured/captured | **genuine-visual-mismatch** | pass (13.6% painted) | pass (37.2% painted) | 51.53 % | 86.05 | focus,action-button-order | heatmaps/backstage-open.open.png |
| `backstage-options.open` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (35.7% painted) | 42.50 % | 82.56 | focus,action-button-order | heatmaps/backstage-options.open.png |
| `backstage-print.open` | captured/captured | **genuine-visual-mismatch** | pass (7.2% painted) | pass (8.7% painted) | 22.44 % | 32.50 | focus | heatmaps/backstage-print.open.png |
| `backstage-save-as.open` | captured/captured | **genuine-visual-mismatch** | pass (11.6% painted) | pass (36.7% painted) | 49.39 % | 82.14 | focus,action-button-order | heatmaps/backstage-save-as.open.png |
| `backstage-share.open` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (36.4% painted) | 43.36 % | 82.82 | focus,action-button-order | heatmaps/backstage-share.open.png |
| `bookmark-manager.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (31.2% painted) | 40.46 % | 27.54 | focus | heatmaps/bookmark-manager.initial.png |
| `bookmark-manager.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (31.2% painted) | 40.46 % | 27.54 | focus | heatmaps/bookmark-manager.populated.png |
| `bookmark-manager.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (31.2% painted) | 40.46 % | 27.54 | focus | heatmaps/bookmark-manager.validation-error.png |
| `borders-and-shading.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.8% painted) | 24.68 % | 30.63 | focus,default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.initial.png |
| `borders-and-shading.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.8% painted) | 24.68 % | 30.63 | focus,default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.populated.png |
| `borders-and-shading.tab-borders` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-page-border` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.tab-shading` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `borders-and-shading.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.4% painted) | pass (3.8% painted) | 24.79 % | 30.79 | focus,default-button,cancel-button,action-button-order | heatmaps/borders-and-shading.validation-error.png |
| `building-blocks-organizer.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (19.7% painted) | 31.43 % | 28.83 | focus | heatmaps/building-blocks-organizer.initial.png |
| `building-blocks-organizer.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (19.7% painted) | 31.44 % | 28.85 | focus | heatmaps/building-blocks-organizer.populated.png |
| `building-blocks-organizer.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (19.7% painted) | 31.43 % | 28.85 | focus | heatmaps/building-blocks-organizer.validation-error.png |
| `chart-axis-titles.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (1.2% painted) | 11.57 % | 24.43 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.initial.png |
| `chart-axis-titles.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.6% painted) | 12.02 % | 25.03 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.populated.png |
| `chart-axis-titles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.70 % | 24.59 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-axis-titles.validation-error.png |
| `chart-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.68 % | 24.51 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-size.initial.png |
| `chart-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.3% painted) | 11.68 % | 24.51 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-size.populated.png |
| `chart-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.4% painted) | 11.79 % | 24.65 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-size.validation-error.png |
| `chart-title.initial` | captured/captured | **genuine-visual-mismatch** | pass (1.8% painted) | pass (0.9% painted) | 10.72 % | 23.68 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-title.initial.png |
| `chart-title.populated` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (1.1% painted) | 11.02 % | 24.10 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-title.populated.png |
| `chart-title.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (1.9% painted) | pass (0.9% painted) | 10.84 % | 23.84 | focus,default-button,cancel-button,action-button-order | heatmaps/chart-title.validation-error.png |
| `columns.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.1% painted) | 14.77 % | 25.42 | focus,action-button-order | heatmaps/columns.initial.png |
| `columns.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.1% painted) | 14.77 % | 25.42 | focus,action-button-order | heatmaps/columns.populated.png |
| `columns.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.3% painted) | pass (1.2% painted) | 14.91 % | 25.61 | focus,action-button-order | heatmaps/columns.validation-error.png |
| `compare-documents.initial` | captured/captured | **product-parity-gap** | pass (2.5% painted) | pass (1.9% painted) |  |  |  |  |
| `compare-documents.populated` | captured/captured | **product-parity-gap** | pass (2.6% painted) | pass (1.9% painted) |  |  |  |  |
| `compare-documents.tab-more` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `compare-documents.validation-error` | captured/captured | **product-parity-gap** | pass (2.6% painted) | pass (1.8% painted) |  |  |  |  |
| `cross-reference.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.6% painted) | 42.14 % | 30.35 | focus,default-button,cancel-button,action-button-order | heatmaps/cross-reference.initial.png |
| `cross-reference.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.6% painted) | 42.14 % | 30.35 | focus,default-button,cancel-button,action-button-order | heatmaps/cross-reference.populated.png |
| `cross-reference.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (29.6% painted) | 42.14 % | 30.35 | focus,default-button,cancel-button,action-button-order | heatmaps/cross-reference.validation-error.png |
| `custom-paragraph-spacing.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (1.5% painted) | 12.71 % | 25.16 | focus | heatmaps/custom-paragraph-spacing.initial.png |
| `custom-paragraph-spacing.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.0% painted) | pass (1.5% painted) | 12.71 % | 25.16 | focus | heatmaps/custom-paragraph-spacing.populated.png |
| `custom-paragraph-spacing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.1% painted) | pass (1.6% painted) | 12.85 % | 25.35 | focus | heatmaps/custom-paragraph-spacing.validation-error.png |
| `customize-theme-colors.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 21.30 % | 33.41 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.initial.png |
| `customize-theme-colors.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 21.30 % | 33.41 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.populated.png |
| `customize-theme-colors.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.9% painted) | pass (6.3% painted) | 21.32 % | 33.44 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-colors.validation-error.png |
| `customize-theme-fonts.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.6% painted) | 12.81 % | 25.36 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.initial.png |
| `customize-theme-fonts.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.6% painted) | 12.81 % | 25.36 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.populated.png |
| `customize-theme-fonts.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.8% painted) | pass (1.6% painted) | 12.87 % | 25.43 | focus,default-button,cancel-button,action-button-order | heatmaps/customize-theme-fonts.validation-error.png |
| `date-time.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 37.86 % | 29.99 | focus,default-button,cancel-button,action-button-order | heatmaps/date-time.initial.png |
| `date-time.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 37.86 % | 29.99 | focus,default-button,cancel-button,action-button-order | heatmaps/date-time.populated.png |
| `date-time.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (27.5% painted) | 37.86 % | 29.99 | focus,default-button,cancel-button,action-button-order | heatmaps/date-time.validation-error.png |
| `document-inspector.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.2% painted) | 13.47 % | 25.95 | focus,default-button,cancel-button,action-button-order | heatmaps/document-inspector.initial.png |
| `document-inspector.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.2% painted) | 13.47 % | 25.95 | focus,default-button,cancel-button,action-button-order | heatmaps/document-inspector.populated.png |
| `document-inspector.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (1.2% painted) | 13.47 % | 25.95 | focus,default-button,cancel-button,action-button-order | heatmaps/document-inspector.validation-error.png |
| `drop-cap-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 12.39 % | 25.54 | focus,action-button-order | heatmaps/drop-cap-options.initial.png |
| `drop-cap-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 12.39 % | 25.54 | focus,action-button-order | heatmaps/drop-cap-options.populated.png |
| `drop-cap-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.6% painted) | 12.44 % | 25.60 | focus,action-button-order | heatmaps/drop-cap-options.validation-error.png |
| `find-replace.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (2.6% painted) | 19.27 % | 28.52 | focus,action-button-order | heatmaps/find-replace.initial.png |
| `find-replace.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.7% painted) | pass (2.4% painted) | 19.17 % | 28.52 | focus,action-button-order | heatmaps/find-replace.populated.png |
| `find-replace.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.8% painted) | pass (2.6% painted) | 19.36 % | 28.68 | focus,action-button-order | heatmaps/find-replace.validation-error.png |
| `font.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.67 % | 46.15 | focus,default-button,cancel-button,action-button-order | heatmaps/font.initial.png |
| `font.populated` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.67 % | 46.15 | focus,default-button,cancel-button,action-button-order | heatmaps/font.populated.png |
| `font.tab-advanced` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `font.tab-font` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `font.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (12.4% painted) | pass (1.9% painted) | 28.67 % | 46.15 | focus,default-button,cancel-button,action-button-order | heatmaps/font.validation-error.png |
| `footnote-endnote-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.5% painted) | 25.34 % | 29.79 | focus,default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.initial.png |
| `footnote-endnote-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.5% painted) | 25.34 % | 29.79 | focus,default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.populated.png |
| `footnote-endnote-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.8% painted) | pass (2.6% painted) | 25.49 % | 29.99 | focus,default-button,cancel-button,action-button-order | heatmaps/footnote-endnote-options.validation-error.png |
| `hyphenation-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.7% painted) | 12.75 % | 25.92 | focus,action-button-order | heatmaps/hyphenation-options.initial.png |
| `hyphenation-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.7% painted) | 12.75 % | 25.92 | focus,action-button-order | heatmaps/hyphenation-options.populated.png |
| `hyphenation-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.6% painted) | pass (1.8% painted) | 12.87 % | 26.09 | focus,action-button-order | heatmaps/hyphenation-options.validation-error.png |
| `icon-picker.initial` | captured/captured | **genuine-visual-mismatch** | pass (12.6% painted) | pass (40.0% painted) | 76.85 % | 64.88 | focus,action-button-order | heatmaps/icon-picker.initial.png |
| `icon-picker.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (0.8% painted) | 11.59 % | 23.95 | focus | heatmaps/icon-picker.populated.png |
| `icon-picker.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (0.8% painted) | 11.70 % | 24.10 | focus | heatmaps/icon-picker.validation-error.png |
| `image-adjust.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.3% painted) | 13.58 % | 26.34 | focus,default-button,cancel-button,action-button-order | heatmaps/image-adjust.initial.png |
| `image-adjust.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.4% painted) | pass (2.3% painted) | 13.58 % | 26.34 | focus,default-button,cancel-button,action-button-order | heatmaps/image-adjust.populated.png |
| `image-adjust.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.5% painted) | pass (2.4% painted) | 13.73 % | 26.54 | focus,default-button,cancel-button,action-button-order | heatmaps/image-adjust.validation-error.png |
| `image-border.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (1.8% painted) | 14.44 % | 25.53 | focus,default-button,cancel-button,action-button-order | heatmaps/image-border.initial.png |
| `image-border.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (2.1% painted) | 14.76 % | 25.99 | focus,default-button,cancel-button,action-button-order | heatmaps/image-border.populated.png |
| `image-border.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.2% painted) | pass (1.9% painted) | 14.57 % | 25.69 | focus,default-button,cancel-button,action-button-order | heatmaps/image-border.validation-error.png |
| `image-crop.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.6% painted) | 14.18 % | 26.85 | focus,default-button,cancel-button,action-button-order | heatmaps/image-crop.initial.png |
| `image-crop.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.6% painted) | 14.18 % | 26.85 | focus,default-button,cancel-button,action-button-order | heatmaps/image-crop.populated.png |
| `image-crop.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.7% painted) | pass (2.6% painted) | 14.26 % | 26.95 | focus,default-button,cancel-button,action-button-order | heatmaps/image-crop.validation-error.png |
| `image-position.initial` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (1.9% painted) | 17.57 % | 26.48 | focus,default-button,cancel-button,action-button-order | heatmaps/image-position.initial.png |
| `image-position.populated` | captured/captured | **genuine-visual-mismatch** | pass (8.2% painted) | pass (1.9% painted) | 17.57 % | 26.48 | focus,default-button,cancel-button,action-button-order | heatmaps/image-position.populated.png |
| `image-position.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (8.3% painted) | pass (2.0% painted) | 17.69 % | 26.63 | focus,default-button,cancel-button,action-button-order | heatmaps/image-position.validation-error.png |
| `image-size.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 11.85 % | 24.74 | focus,default-button,cancel-button,action-button-order | heatmaps/image-size.initial.png |
| `image-size.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.4% painted) | pass (1.5% painted) | 11.85 % | 24.74 | focus,default-button,cancel-button,action-button-order | heatmaps/image-size.populated.png |
| `image-size.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.5% painted) | pass (1.5% painted) | 11.91 % | 24.83 | focus,default-button,cancel-button,action-button-order | heatmaps/image-size.validation-error.png |
| `insert-chart.initial` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.2% painted) | 32.67 % | 30.71 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-chart.initial.png |
| `insert-chart.populated` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.2% painted) | 32.67 % | 30.71 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-chart.populated.png |
| `insert-chart.tab-category` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `insert-chart.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (23.0% painted) | pass (2.2% painted) | 32.65 % | 30.65 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-chart.validation-error.png |
| `insert-smart-art.initial` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (22.2% painted) | 38.64 % | 33.09 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.initial.png |
| `insert-smart-art.populated` | captured/captured | **genuine-visual-mismatch** | pass (11.1% painted) | pass (22.2% painted) | 38.64 % | 33.09 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.populated.png |
| `insert-smart-art.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.7% painted) | pass (22.3% painted) | 37.07 % | 30.10 | focus,default-button,cancel-button,action-button-order | heatmaps/insert-smart-art.validation-error.png |
| `legal-notices.initial` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `legal-notices.populated` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `legal-notices.validation-error` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `line-number-options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (1.0% painted) | 14.82 % | 25.33 | focus | heatmaps/line-number-options.initial.png |
| `line-number-options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.6% painted) | pass (1.0% painted) | 14.82 % | 25.33 | focus | heatmaps/line-number-options.populated.png |
| `line-number-options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.7% painted) | pass (1.1% painted) | 14.96 % | 25.53 | focus | heatmaps/line-number-options.validation-error.png |
| `manage-styles.initial` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (24.5% painted) | 63.89 % | 47.62 | focus,action-button-order | heatmaps/manage-styles.initial.png |
| `manage-styles.populated` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (24.5% painted) | 63.89 % | 47.62 | focus,action-button-order | heatmaps/manage-styles.populated.png |
| `manage-styles.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (7.5% painted) | pass (24.5% painted) | 63.89 % | 47.62 | focus,action-button-order | heatmaps/manage-styles.validation-error.png |
| `mark-citation.initial` | captured/captured | **genuine-visual-mismatch** | pass (6.2% painted) | pass (1.5% painted) | 15.90 % | 26.09 | focus,cancel-button,action-button-order | heatmaps/mark-citation.initial.png |
| `mark-citation.populated` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (1.6% painted) | 15.95 % | 26.21 | focus,cancel-button,action-button-order | heatmaps/mark-citation.populated.png |
| `mark-citation.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (6.3% painted) | pass (1.6% painted) | 15.98 % | 26.27 | focus,cancel-button,action-button-order | heatmaps/mark-citation.validation-error.png |
| `multilevel-list.initial` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.5% painted) | 38.59 % | 45.16 | focus,default-button,cancel-button,action-button-order | heatmaps/multilevel-list.initial.png |
| `multilevel-list.populated` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.5% painted) | 38.59 % | 45.16 | focus,default-button,cancel-button,action-button-order | heatmaps/multilevel-list.populated.png |
| `multilevel-list.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (24.2% painted) | pass (2.6% painted) | 38.76 % | 45.36 | focus,default-button,cancel-button,action-button-order | heatmaps/multilevel-list.validation-error.png |
| `options.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (8.2% painted) | 19.89 % | 27.73 | focus,default-button,cancel-button,action-button-order | heatmaps/options.initial.png |
| `options.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (8.2% painted) | 19.91 % | 27.75 | focus,default-button,cancel-button,action-button-order | heatmaps/options.populated.png |
| `options.tab-auto-correct` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (8.4% painted) | 24.19 % | 32.42 | focus,default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-correct.png |
| `options.tab-auto-format-as-you-type` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (8.4% painted) | 24.19 % | 32.42 | focus,default-button,cancel-button,action-button-order | heatmaps/options.tab-auto-format-as-you-type.png |
| `options.tab-general` | captured/captured | **genuine-visual-mismatch** | pass (9.1% painted) | pass (8.4% painted) | 24.19 % | 32.42 | focus,default-button,cancel-button,action-button-order | heatmaps/options.tab-general.png |
| `options.tab-replace` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `options.tab-with` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `options.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.4% painted) | pass (8.2% painted) | 20.01 % | 27.89 | focus,default-button,cancel-button,action-button-order | heatmaps/options.validation-error.png |
| `page-setup.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (2.6% painted) | 24.51 % | 30.53 | focus,action-button-order | heatmaps/page-setup.initial.png |
| `page-setup.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.8% painted) | pass (2.6% painted) | 24.51 % | 30.53 | focus,action-button-order | heatmaps/page-setup.populated.png |
| `page-setup.tab-layout` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (1.5% painted) | 16.53 % | 26.53 | focus,action-button-order | heatmaps/page-setup.tab-layout.png |
| `page-setup.tab-margins` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (1.5% painted) | 16.53 % | 26.53 | focus,action-button-order | heatmaps/page-setup.tab-margins.png |
| `page-setup.tab-paper` | captured/captured | **genuine-visual-mismatch** | pass (6.7% painted) | pass (1.5% painted) | 16.53 % | 26.53 | focus,action-button-order | heatmaps/page-setup.tab-paper.png |
| `page-setup.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.9% painted) | pass (2.7% painted) | 24.62 % | 30.70 | focus,action-button-order | heatmaps/page-setup.validation-error.png |
| `paragraph.initial` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (3.7% painted) | 33.59 % | 51.68 | focus,action-button-order | heatmaps/paragraph.initial.png |
| `paragraph.populated` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (3.7% painted) | 33.59 % | 51.68 | focus,action-button-order | heatmaps/paragraph.populated.png |
| `paragraph.tab-indents-and-spacing` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (2.6% painted) | 31.56 % | 50.78 | focus,action-button-order | heatmaps/paragraph.tab-indents-and-spacing.png |
| `paragraph.tab-line-and-page-breaks` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (2.6% painted) | 31.56 % | 50.78 | focus,action-button-order | heatmaps/paragraph.tab-line-and-page-breaks.png |
| `paragraph.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (14.0% painted) | pass (3.8% painted) | 33.77 % | 51.88 | focus,action-button-order | heatmaps/paragraph.validation-error.png |
| `password-prompt.initial` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `password-prompt.populated` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `password-prompt.validation-error` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `paste-special.initial` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (20.7% painted) | 83.31 % | 71.38 | focus,default-button,cancel-button,action-button-order | heatmaps/paste-special.initial.png |
| `paste-special.populated` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (20.7% painted) | 83.31 % | 71.38 | focus,default-button,cancel-button,action-button-order | heatmaps/paste-special.populated.png |
| `paste-special.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (13.3% painted) | pass (20.7% painted) | 83.31 % | 71.38 | focus,default-button,cancel-button,action-button-order | heatmaps/paste-special.validation-error.png |
| `properties.initial` | captured/captured | **genuine-visual-mismatch** | pass (3.8% painted) | pass (2.3% painted) | 14.50 % | 26.88 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.initial.png |
| `properties.populated` | captured/captured | **genuine-visual-mismatch** | pass (3.9% painted) | pass (2.4% painted) | 14.65 % | 27.04 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.populated.png |
| `properties.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (3.9% painted) | pass (2.4% painted) | 14.64 % | 27.05 | focus,default-button,cancel-button,action-button-order | heatmaps/properties.validation-error.png |
| `restrict-editing.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.8% painted) | 16.32 % | 27.02 | focus,default-button,action-button-order | heatmaps/restrict-editing.initial.png |
| `restrict-editing.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.8% painted) | 16.34 % | 27.03 | focus,default-button,action-button-order | heatmaps/restrict-editing.populated.png |
| `restrict-editing.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.8% painted) | pass (3.9% painted) | 16.37 % | 27.06 | focus,default-button,action-button-order | heatmaps/restrict-editing.validation-error.png |
| `screen-clip-overlay.open` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `sort.initial` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (6.0% painted) | 18.02 % | 27.62 | focus,default-button,cancel-button,action-button-order | heatmaps/sort.initial.png |
| `sort.populated` | captured/captured | **genuine-visual-mismatch** | pass (5.1% painted) | pass (6.0% painted) | 18.08 % | 27.68 | focus,default-button,cancel-button,action-button-order | heatmaps/sort.populated.png |
| `sort.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (5.0% painted) | pass (6.0% painted) | 18.02 % | 27.62 | focus,default-button,cancel-button,action-button-order | heatmaps/sort.validation-error.png |
| `style.initial` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (4.1% painted) | 40.57 % | 46.48 | focus,default-button,cancel-button,action-button-order | heatmaps/style.initial.png |
| `style.populated` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (4.2% painted) | 40.60 % | 46.68 | focus,default-button,cancel-button,action-button-order | heatmaps/style.populated.png |
| `style.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (25.8% painted) | pass (4.2% painted) | 40.60 % | 46.67 | focus,default-button,cancel-button,action-button-order | heatmaps/style.validation-error.png |
| `symbol-picker.initial` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `symbol-picker.populated` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `symbol-picker.validation-error` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-formula.initial` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-formula.populated` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-formula.validation-error` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-of-authorities.initial` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.0% painted) | 18.39 % | 26.15 | focus,default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.initial.png |
| `table-of-authorities.populated` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.0% painted) | 18.39 % | 26.15 | focus,default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.populated.png |
| `table-of-authorities.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (9.0% painted) | pass (1.0% painted) | 18.39 % | 26.15 | focus,default-button,cancel-button,action-button-order | heatmaps/table-of-authorities.validation-error.png |
| `table-properties.initial` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.populated` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.tab-cell` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.tab-column` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.tab-row` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.tab-table` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `table-properties.validation-error` | host-missing | **product-parity-gap** |  |  |  |  |  |  |
| `tabs.initial` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (21.9% painted) | 38.83 % | 30.80 | focus,default-button,cancel-button,action-button-order | heatmaps/tabs.initial.png |
| `tabs.populated` | captured/captured | **genuine-visual-mismatch** | pass (10.3% painted) | pass (21.9% painted) | 38.86 % | 30.84 | focus,default-button,cancel-button,action-button-order | heatmaps/tabs.populated.png |
| `tabs.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (10.4% painted) | pass (22.0% painted) | 38.99 % | 31.03 | focus,default-button,cancel-button,action-button-order | heatmaps/tabs.validation-error.png |
| `watermark.initial` | captured/captured | **genuine-visual-mismatch** | pass (4.0% painted) | pass (2.6% painted) | 14.75 % | 27.70 | focus,default-button,cancel-button,action-button-order | heatmaps/watermark.initial.png |
| `watermark.populated` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (2.7% painted) | 14.87 % | 27.88 | focus,default-button,cancel-button,action-button-order | heatmaps/watermark.populated.png |
| `watermark.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (4.1% painted) | pass (2.7% painted) | 14.87 % | 27.89 | focus,default-button,cancel-button,action-button-order | heatmaps/watermark.validation-error.png |
| `word-count.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.8% painted) | 11.49 % | 24.83 | focus,default-button,cancel-button,action-button-order | heatmaps/word-count.initial.png |
| `word-count.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.8% painted) | 11.49 % | 24.83 | focus,default-button,cancel-button,action-button-order | heatmaps/word-count.populated.png |
| `word-count.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.2% painted) | pass (0.8% painted) | 11.49 % | 24.83 | focus,default-button,cancel-button,action-button-order | heatmaps/word-count.validation-error.png |
| `zoom.initial` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.0% painted) | 11.69 % | 24.29 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.initial.png |
| `zoom.populated` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.0% painted) | 11.69 % | 24.29 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.populated.png |
| `zoom.tab-zoom-to` | host-missing | **state-not-applicable** |  |  |  |  |  |  |
| `zoom.validation-error` | captured/captured | **genuine-visual-mismatch** | pass (2.3% painted) | pass (1.1% painted) | 11.74 % | 24.36 | focus,default-button,cancel-button,action-button-order | heatmaps/zoom.validation-error.png |
| `bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.6% painted) |  |  |  |  |
| `bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.5% painted) |  |  |  |  |
| `bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.5% painted) |  |  |  |  |
| `cell-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `cell-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `cell-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `citation-source-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `citation-source-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `citation-source-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (25.6% painted) |  |  |  |  |
| `comment-list.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `comment-list.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `comment-list.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `comment-reply.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `comment-reply.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `comment-reply.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `cups-print.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `cups-print.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.4% painted) |  |  |  |  |
| `cups-print.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.5% painted) |  |  |  |  |
| `draw-table-dimension.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `draw-table-dimension.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.0% painted) |  |  |  |  |
| `draw-table-dimension.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.1% painted) |  |  |  |  |
| `field-picker.initial` | avalonia-extension | **avalonia-extension** |  | pass (34.2% painted) |  |  |  |  |
| `field-picker.populated` | avalonia-extension | **avalonia-extension** |  | pass (34.2% painted) |  |  |  |  |
| `field-picker.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (34.2% painted) |  |  |  |  |
| `hyperlink.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `hyperlink.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.1% painted) |  |  |  |  |
| `hyperlink.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.4% painted) |  |  |  |  |
| `image-alt-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `image-alt-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.3% painted) |  |  |  |  |
| `image-alt-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.1% painted) |  |  |  |  |
| `link-bookmark.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `link-bookmark.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `link-bookmark.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `manage-sources.initial` | avalonia-extension | **avalonia-extension** |  | pass (26.4% painted) |  |  |  |  |
| `manage-sources.populated` | avalonia-extension | **avalonia-extension** |  | pass (26.4% painted) |  |  |  |  |
| `manage-sources.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (26.4% painted) |  |  |  |  |
| `note-text.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `note-text.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `note-text.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.1% painted) |  |  |  |  |
| `notes-pane.seeded` | avalonia-extension | **avalonia-extension** |  | pass (9.6% painted) |  |  |  |  |
| `page-borders.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-borders.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-borders.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `page-color.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `page-color.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `page-color.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.0% painted) |  |  |  |  |
| `page-number-format.initial` | avalonia-extension | **avalonia-extension** |  | pass (3.7% painted) |  |  |  |  |
| `page-number-format.populated` | avalonia-extension | **avalonia-extension** |  | pass (3.7% painted) |  |  |  |  |
| `page-number-format.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (3.8% painted) |  |  |  |  |
| `print-preview.initial` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `print-preview.populated` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `print-preview.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (18.3% painted) |  |  |  |  |
| `proofing-language.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `proofing-language.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `proofing-language.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part-name.initial` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `quick-part-name.populated` | avalonia-extension | **avalonia-extension** |  | pass (2.2% painted) |  |  |  |  |
| `quick-part-name.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (2.3% painted) |  |  |  |  |
| `quick-part.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.9% painted) |  |  |  |  |
| `quick-part.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `quick-part.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `save-compatibility-warning.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `save-compatibility-warning.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `save-compatibility-warning.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.1% painted) |  |  |  |  |
| `screen-tip.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `screen-tip.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `screen-tip.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.7% painted) |  |  |  |  |
| `set-as-default-confirmation.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `set-as-default-confirmation.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `set-as-default-confirmation.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.6% painted) |  |  |  |  |
| `smart-art-edit.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `smart-art-edit.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.9% painted) |  |  |  |  |
| `smart-art-edit.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `source-author-editor.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.8% painted) |  |  |  |  |
| `source-author-editor.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.8% painted) |  |  |  |  |
| `source-author-editor.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.8% painted) |  |  |  |  |
| `source-conflict-resolution.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `source-conflict-resolution.populated` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `source-conflict-resolution.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.8% painted) |  |  |  |  |
| `source-entry.initial` | avalonia-extension | **avalonia-extension** |  | pass (4.3% painted) |  |  |  |  |
| `source-entry.populated` | avalonia-extension | **avalonia-extension** |  | pass (4.5% painted) |  |  |  |  |
| `source-entry.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (4.4% painted) |  |  |  |  |
| `style-set.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `style-set.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `style-set.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `table-text-conversion.initial` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `table-text-conversion.populated` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `table-text-conversion.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (14.5% painted) |  |  |  |  |
| `theme-effects.initial` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `theme-effects.populated` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `theme-effects.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (0.5% painted) |  |  |  |  |
| `thesaurus.initial` | avalonia-extension | **avalonia-extension** |  | pass (1.2% painted) |  |  |  |  |
| `thesaurus.populated` | avalonia-extension | **avalonia-extension** |  | pass (8.3% painted) |  |  |  |  |
| `thesaurus.validation-error` | avalonia-extension | **avalonia-extension** |  | pass (1.2% painted) |  |  |  |  |

## Honest Limitations

Native file/printer pickers, OS-owned modal focus, and host callbacks requiring a live shell are not inferred from semantic checks. They remain `native-picker-platform-limitation` or `capture-hook-required` until a foreground adapter records app-owned evidence.
