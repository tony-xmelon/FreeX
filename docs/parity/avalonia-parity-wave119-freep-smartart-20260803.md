# Avalonia parity Wave119: FreeP SmartArt `/layout/default`

## Audit choice

The checked-in fixture `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx`,
slide 4, declares `/layout/default`. The other three layouts in the deck,
`increasingCircleProcess`, `hierarchy3`, and `cycle2`, already have bounded
coverage. The earlier probe note in
`docs/parity/freep-smartart-default-live-probe-rejected-20260718.md` correctly
rejected generic vertical List admission after the WPF result regressed to
22.5894%, but its description of the cache as a two-column snake was
imprecise.

Direct inspection of `ppt/diagrams/drawing4.xml` shows five equal rectangle
slots inside the SmartArt frame: the upper row starts at local x values
`0`, `3754437`, and `7508875`; the lower row starts at `1877218` and
`5631656`. Every slot is `3413125 x 2047875` EMU. The first four slots contain
`Requirement 1` through `Requirement 4`; the fifth slot is an intentionally
empty template node. This is a staggered three-over-two arrangement, not a
generic vertical list.

## Implementation and causal proof

- The reader classifies the generic `/default` layout as List but promotes it
  only when the exact five-node/five-rectangle cache signature is present.
  It requires the four texts in order, an empty fifth node and shape, equal
  dimensions, the package's one-EMU distributed top-row steps, midpoint lower
  slots, and empty authored DrawingML effect lists.
- The parser treats a blank `dgm:pt @type` as an ordinary node. This is required
  by the fixture: the parsed model contains all five nodes, including the
  empty fifth template node.
- The shared `SmartArtLayoutEngine` emits the same five rectangle slots. The
  width is `5/16` (`0.3125`) of the frame, the height is `3/5` of that width,
  and integer midpoint placement preserves the package's exact EMU values.
  The empty fifth slot remains in the editable live plan with no paragraphs.
- `SmartArtTests.RenderCompareCorpus_DefaultList_IsAdmittedOnlyForTheAuditedStaggeredCache`
  proves the package coordinates, dimensions, texts, admission, and live
  geometry match one another exactly. The presentation tests prove the
  compositor chooses live text over a cached fallback and preserves the
  empty slot.
- Synthetic near-misses for wrong slot count, one-EMU geometry, and text stay
  cached. A synthetic outer-shadow cache also stays cached; after save/reopen,
  the effect XML and five-shape fallback remain present.
- The Wave118 cycle2 shape and drawing effect checks were generalized and are
  reused by `/default`; no parallel default-only effect predicate was added.
  WPF and Avalonia renderer contract tests verify that both `SlideCanvas`
  implementations consume shared compositor output rather than owning
  separate SmartArt geometry.

## Verification boundary

This slice establishes package-level and shared-renderer causal evidence. It
does not claim PowerPoint-pixel identity or broad `/layout/default` support.
Only this audited five-slot cache is admitted; other default/list packages,
effect-bearing drawings, different slot counts, and different geometry remain
on the preserved cached-drawing path. The simple live style projection also
does not claim to reproduce every PowerPoint theme/effect detail. The existing
PowerPoint baseline measurements in the rejected-probe note remain historical
evidence; no new pixel percentage is claimed here without a fresh renderer
capture.
