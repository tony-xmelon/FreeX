# FreeW Borders and Shading Dialog Parity

The Avalonia `Borders and Shading` dialog now follows the WPF authority structure and chrome.

## Changes

- Match the WPF 420px dialog width and compact 20px control / 21px action metrics.
- Render `Borders`, `Page Border`, and `Shading` as the same three classic tabs as WPF.
- Match WPF field order, labels, margins, 160px fields, edge rows, colour swatches, and action-button sizing.
- Use the shared localized `_OK` / `_Cancel` strings so default, cancel, and action-order semantics match WPF.
- Keep the existing shared planner, validation, and apply behavior unchanged.
- Fix the visual inventory scanner to discover tab headers within each class body, avoiding false tab states for sibling dialogs in the same source file.

## Evidence

Fresh paired run from this branch:

- Inventory: 156 routes, 462 scenarios; 186 WPF and 276 Avalonia captures.
- All WPF and Avalonia captures passed the harness content gates.
- Borders and Shading initial, populated, and Borders-tab states: 11.52% changed pixels, 6.21 mean channel delta.
- Page Border tab: 15.16% changed pixels, 6.84 mean channel delta.
- Shading tab: 8.20% changed pixels, 3.85 mean channel delta.
- Validation state: 11.64% changed pixels, 6.37 mean channel delta.
- Action semantics: matched (`_OK`, `_Cancel`, order, default, and cancel metadata).

The previous stacked Avalonia layout measured about 21% changed pixels for the paired default states. The remaining delta is a genuine Avalonia/WPF framework rendering difference in control templates, text rasterization, and tab-pane geometry; it remains classified as a visual mismatch.

The original pre-sync evidence is preserved in the ignored branch-local directories `artifacts/freew-borders-round2-wpf-final`, `artifacts/freew-borders-round2-avalonia-final2`, and `artifacts/freew-borders-round2-compare-final2`. The post-sync paired evidence is in `artifacts/freew-borders-round2-synced-wpf`, `artifacts/freew-borders-round2-synced-avalonia`, and `artifacts/freew-borders-round2-synced-compare`; its freshness check passes against the regenerated inventory. The post-sync counts and metrics are unchanged.
