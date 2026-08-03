# Avalonia parity Wave131: FreeP SmartArt hierarchy3 live import

## Selection and authority

Wave131 selects the real `hierarchy3` SmartArt cache in
`tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx`, slide 2. Before this
slice the reader deliberately kept that import on the cached `dsp:drawing`
path. The cache contains four rounded node boxes, two empty rounded template
leaves, and four empty line segments:
PowerPoint uses an orthogonal two-segment route for some of the three parent
edges. The existing shared planner already models the corresponding four-node
left-to-right hierarchy as editable boxes plus one straight connector per
modeled parent edge, but the import guard rejected the observed four-segment grammar.

The real `dsp:drawing` cache and parsed diagram data node tree are the authority
for admission. The shared `SmartArtLayoutEngine` remains the authority for the
renderer-neutral live plan consumed by both WPF and Avalonia through
`SlideCompositor`.

## Implementation

- `CanUseHierarchy3NodeAndConnectorCache` now admits only a complete node-plus-
  template cache with zero or two empty rounded template leaves, and either one
  line per modeled parent edge or the observed four-segment orthogonal cache.
- Any extra role, background, group, picture, shape effect, or raw DrawingML
  effect keeps the cached drawing authoritative.
- The generator inventory now includes a fifth pure-XML fixture entry for
  `hierarchy3` with the representative four-node/four-segment cache. Its
  PowerPoint path emits the same hierarchy3 identity on slide 3.
- WPF and Avalonia source contracts verify that both hosts consume shared
  compositor output and do not own SmartArt geometry.

## Evidence and boundaries

The host corpus regression verifies the real layout ID, family, four node
texts, two empty template leaves, four cached connector segments, live-plan
count, and replacement of the ten-shape cached composition with the
six-shape shared plan. The paired
renderer contracts verify the host boundary, not pixel identity.

This does not claim PowerPoint-identical orthogonal connector routing, text
fitting, effects, or all hierarchy3 cache roles. Richer or effect-bearing
hierarchy3 imports remain cached. The exact named residuals in the current
known SmartArt catalog are:

- `groupedList` imports, whose authoring plan exists but whose imported cache
  still contains unmodeled roles;
- `/layout/default` variants other than the audited five-slot staggered cache;
- picture layouts with missing, partial, or ambiguous node-image mappings;
- effect-bearing or extra-role caches for every family, including `cycle2` and
  `hierarchy3`; and
- unknown or future layout IDs outside the bounded catalog.

No whole known family is being reclassified in this wave. The known families
remain Process, List, Cycle, Hierarchy, Matrix, and Relationship/Venn; the
remaining work is the bounded cache evidence and richer variant work listed
above.
