# FreeW nested DrawingML groups

## Accepted scope

FreeW now retains nested `wpg:wgp` children as nested `DrawingGroup` model objects rather than reducing them to placeholders. The writer emits their local `a:xfrm` transform, including rotation and flips, and recursively collects native image, chart, and SmartArt package relationships. The shared visual plan and both WPF and Avalonia hosts render nested children through the same typed paths as top-level group children.

## Evidence

- DOCX nested-group round trip: 17/17 `DrawingGroupRoundTripTests`, including nested native-image payload retention.
- Shared visual-plan tests: 23/23 `DrawingObjectVisualPlannerTests`.
- WPF nested visual contract: 1/1 compiled and 1/1 `--no-build` rerun.
- Avalonia floating-object regression lane: 46/46.

This is source-backed functional and visual capability parity. It does not claim pixel-level equivalence for every DrawingML child effect.
