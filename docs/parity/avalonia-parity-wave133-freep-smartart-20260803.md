# FreeP Wave133 SmartArt parity

Date: 2026-08-03
Branch: `codex/avalonia-parity-wave133-freep-smartart-20260803`
Base: `38f9edb411`

## Selected real fixture

The selected evidence is the checked-in generated `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide 7, with layout UID ending in `/relationship1`. It is a complete PPTX package with PresentationML slide relationships, `dgm:dataModel`, `dgm:layoutDef`, and `dsp:drawing` parts consumed by `PptxPackageReader`.

The exact grammar is **3 ordered node ellipses**: `Audience`, `Need`, and `Offer`. The cached drawing has **3 shapes**, all `AutoShape/Ellipse`, with equal 2,400,000 EMU square bounds, X positions 1,522,800 / 2,914,800 / 4,306,800, and a common Y position of 1,672,400 EMU. Its horizontal step is exactly 1,392,000 EMU, the shared planner's truncated 58% diameter step; each successive ellipse overlaps the preceding ellipse. The data part has **3 `dgm:pt` nodes** and no parent connections.

## Bounded live path

`PptxPackageReader` admits an imported relationship1 cache only when it has exactly 3 nodes, exactly one non-empty ellipse per node in data order, distinct matching text, positive equal square geometry, a horizontal step within 1 EMU of the shared planner's truncated 58% diameter step, and no shape or drawing effects. The shared `SmartArtLayoutEngine` emits the same ordered overlapping ellipse plan, and `SlideCompositor.Compose` supplies that plan to both WPF and Avalonia.

Package-reader tests cover the real fixture and extra-role/non-ellipse/wrong-ratio fallback boundaries. Layout tests cover the shared three-node plan and cached fallback. WPF/Avalonia source contracts assert that neither renderer owns relationship1 geometry, and generator evidence asserts the slide, layout, drawing, data, and exact geometry counts.

## Fallback residuals

Missing or unreadable data/drawing, duplicate or ambiguous nodes, mismatched text/order, non-ellipse or wrong-ratio/non-overlapping geometry, invalid counts, unsupported shape or drawing effects, pictures, connectors, bands, extra roles, and every other unproven relationship1 cache remain on the preserved cached drawing path. This slice does not claim other relationship families, PowerPoint intersection-region semantics, exact native sizing, effects, or pixel-level PowerPoint baselines.
