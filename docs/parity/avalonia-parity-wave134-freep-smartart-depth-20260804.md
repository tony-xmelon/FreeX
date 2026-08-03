# FreeP Wave 134 SmartArt import depth

Date: 2026-08-04
Branch: `codex/avalonia-parity-wave134-freep-smartart-depth-20260804`

## Selected layout

This slice admits the native `gridMatrix` SmartArt layout from the deterministic
checked-in `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide
8. Its package grammar is exactly four ordered `dgm:pt` nodes (`Axis`, `Speed`,
`Quality`, `Cost`) and four cached `dsp:sp` shapes, each effect-free
`a:prstGeom prst="rect"` with equal square bounds. The cells form a 2x2 row-major
grid with equal horizontal and vertical steps; the gap is the shared planner's
truncated 2.5% of the centered square grid envelope.

## Implementation and contracts

`PptxPackageReader` now admits only that four-cell grammar: non-empty distinct
text in data order, rectangle-only roles, equal positive square cells, matching
row/column steps, the deterministic gap signature, and no unsupported shape or
drawing effects. The existing shared `SmartArtLayoutEngine.LayoutGridMatrix`
plan remains the sole live geometry source, and `SlideCompositor` supplies the
same plan to WPF and Avalonia. Package XML evidence, host reader/composition
tests, presentation fallback tests, and paired renderer source contracts cover
the slice.

## Boundaries

Missing or unreadable parts, wrong counts, duplicate or reordered text,
non-rectangles, non-square or wrongly spaced cells, extra roles, pictures,
connectors, and effect-bearing or otherwise ambiguous caches remain on the
preserved cached-drawing path. This does not claim PowerPoint-identical cell
metrics, effects, text fitting, native layout regeneration, or broader matrix
family import parity.

The FreeP workflow inventory increases from 105 to 106 evidence rows. The
cross-app dashboard is intentionally unchanged.
