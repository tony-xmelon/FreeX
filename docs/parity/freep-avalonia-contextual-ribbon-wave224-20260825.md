# FreeP Avalonia contextual ribbon — Wave 224 (2026-08-25)

FreeP's Avalonia host now supplies a live selection context to the shared ribbon renderer, matching the existing WPF contextual-tab behavior.

- Added `FreePRibbonContextSource`, which maps the selected shapes on the active slide to the shared `text`, `table`, and `smartart` activation keys.
- The source preserves the WPF precedence: a table or SmartArt selection does not also surface the generic Text Format tab.
- The Avalonia host refreshes that source with its normal command-state synchronization and passes it to `AvaloniaRibbonRenderer.BuildRibbon`.
- Focused tests cover the three selection contexts, change suppression, and the host wiring.

The refreshed whole-window catalog completed 36/36 paired scenarios with zero capture limitations. Contextual-tab-strip and ribbon-tab-strip mismatch categories are now **zero**. Rich-text selection retains only the separately documented native glyph-raster delta, and the title-bar-raster category remains an intentional neutral-titlebar heuristic mismatch rather than a contextual-ribbon defect.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
