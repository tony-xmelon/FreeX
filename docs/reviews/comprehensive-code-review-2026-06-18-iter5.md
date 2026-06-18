# FreeX Code Review — 2026-06-18 (Iteration 5: newly-merged slicer + drawing-anchor code)

Fresh review of the ~1.5k lines of slicer-rendering and drawing-anchor fidelity code that landed on `main` during iteration 4 (the `integrate-slicers` and drawing-bounds merges). Two parallel review agents over the slicer pipeline and the drawing-object rendering/anchor geometry. Deliberately excluded the ribbon refactor (an actively-owned parallel workstream).

## Fixed

- **[High] Drawing-object layer cache ignored the new sub-cell offset fields.** `GridView.DrawingObjectLayerCache` hashed `Anchor`/`Width`/`Height` but not `AnchorOffsetX`/`AnchorOffsetY` (newly added to `DrawingShapeModel`/`PictureModel`/`TextBoxModel`). A sub-cell reposition that changed only the offset produced an identical stamp, so the cached layer was never invalidated and the object rendered at its old position. Added the offsets to all three stamp methods.
- **[Medium] Pivot-slicer available-item de-dup was missing.** `SlicerItemResolver.ResolvePivotCacheItems` built the "available" caption list without de-duplication despite its "distinct" contract, so the `selectedFromCache.Count < available.Count` "all-selected ⇒ cleared" heuristic used an inflated denominator and could misclassify the filter state. De-dup both lists (order-preserving) before the comparison.
- **[Low] Slicer selection matching was locale-sensitive.** `GridView.DrawingObjects.DrawNativeSlicerControl` matched selected captions with `StringComparer.CurrentCultureIgnoreCase`; slicer captions are workbook data, not UI text, so a Turkish-style I/i fold could mis-mark a tile. Switched to `OrdinalIgnoreCase`.

## Reviewed and deliberately NOT changed

- **Slicer tile ordering (`SortedSet` in `SlicerTimelinePlanner.BuildSlicerTiles`).** A review agent flagged the `SortedSet` as discarding Excel's native item order. But `SlicerTimelinePlannerTests` **explicitly assert alphabetical ordering** (`{"West","East"}` → `{"East","West"}`), i.e. the sort is a deliberate, tested product decision — not a defect. Reverted my change rather than override a tested choice on a parity opinion; if Excel-native ordering is wanted, that's a product decision for the slicer owners (would require updating those tests).
- **[Medium] Drag-commit leaves stale `AnchorOffsetX/Y`.** A real candidate (a sub-cell move updates `Anchor` but not the offsets, so the object can shift on reposition), but the correct fix (reset vs. recompute the offset on drop) is a design decision inside the actively-churning drawing-interaction/move-command code. Flagged for the drawing-fidelity workstream rather than guessed at here.
- Low items (per-paint `HashSet` allocation in the slicer draw path; `ToDisplayText` `CurrentCulture` formatting; O(sheets×tables) resolver lookups) — acceptable / low-value; noted for the slicer owners.

## Verification
`FreeX.slnx` Release build 0/0; `FreeX.DefaultTests.slnx` all green.
