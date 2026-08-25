# FreeP neutral titlebar raster evidence — Wave 225 (2026-08-25)

The whole-window evidence validator now recognizes FreeP's intentional neutral Office-like caption surface (`#F3F4F6`) as well as an accent-branded titlebar. This corrects an evidence-classification defect; it does not change either production host's chrome.

- The validator accepts a dominant neutral caption raster within the FreeP caption band, while retaining the existing accent check for hosts that use it.
- Neutral acceptance requires at least 80% of sampled pixels to be within two channels of the declared `#F3F4F6` caption surface; the evidence record exposes both neutral-caption and legacy accent ratios.
- The neutral band excludes pure white, so the white-occlusion fixture remains invalid.
- The focused validator suite covers accent, FreeP-neutral, threshold-boundary, wrong-gray, and white-occluded titlebars.
- The regenerated 36/36 paired catalog has zero capture limitations and one explicit mismatch: `rich-editor-selection-pixel-threshold`. The prior `app-owned-titlebar-raster` category is now zero.

That remaining rich-editor mismatch is the separately documented native glyph-raster difference; it is not a titlebar or ribbon defect. Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
