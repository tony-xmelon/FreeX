# FreeP Wave132 SmartArt parity

Date: 2026-08-03
Branch: `codex/avalonia-parity-wave132-freep-smartart-20260803`
Base: `78506b595f`

## Selected real fixture

The selected fixture is the checked-in generated `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide 6, with layout UID ending in `/groupedList`. It is a real package fixture consumed by `PptxPackageReader`, not an inventory-only layout claim.

The fixture's exact imported cache is **8 shapes**: **2** empty `Rectangle` group bands, **2** `RoundedRectangle` group headers (`Plan`, `Build`), and **4** `Rectangle` child boxes (`Scope`, `Schedule`, `Implement`, `Verify`), with **6** non-empty text shapes and **6** matching `dgm:pt` nodes. The cache contains **2** group roles beyond the editable node boxes, which was the previously cached fallback boundary.

## Bounded live path

`PptxPackageReader` admits the cache only when the grouped-list grammar is exact: two or more visible root groups, visible children under every group, one unique text shape per visible node, rounded headers, rectangular children, one distinct enclosing empty rectangle band per group, exact shape counts, containment, and no unsupported shape or drawing effects.

The shared `SmartArtLayoutEngine` then emits the exact same **8-shape** live plan: **2** empty bands, **2** headers, and **4** child boxes. `SlideCompositor.ComposeSmartArt` consumes that plan for both WPF and Avalonia through the existing shared presentation path. The generator and evidence test assert the package-level counts; host and Avalonia contract tests assert that neither host owns a separate SmartArt layout implementation.

## Fallback residuals

The fallback boundary remains intentional. A grouped-list cache with missing, duplicate, ambiguous, or extra bands; mismatched node text; unsupported geometry; unsupported shape/drawing effects; pictures; or any unproven role stays on the preserved cached drawing. Unknown SmartArt layout IDs, incomplete data or drawing parts, and other families continue to use their existing cached fallback unless an existing bounded admission guard proves them live. This change closes only the real grouped-list node-plus-band grammar represented by fixture 15; it does not claim full grouped-list, list-family, or SmartArt-family coverage.
