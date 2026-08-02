# FreeP Wave 112: SmartArt Continuous Block Process

## Scope

Wave 112 closes the admitted `continuousBlockProcess` SmartArt generic-layout
gap. The reader allow-list is unchanged; only this already-admitted process
preset receives dedicated shared geometry.

## Shared implementation

- `SmartArtLayoutEngine` emits a centered compact band of editable rounded
  blocks with explicit ordered connector roles.
- Block and connector names are stable in the live plan and regenerated
  `dsp:drawing` cache, so cache inspection and conversion preserve the preset's
  roles.
- `SlideCompositor` remains the single live-layout route consumed by both WPF
  and Avalonia; neither host owns a second SmartArt geometry implementation.
- Native diagram parts remain preserved and the existing authoring path rewrites
  the layout part and drawing cache without broadening live-layout admission.

## Verification

- `SmartArtLayoutTests` covers dedicated rounded-block geometry, compact gaps,
  connector roles, shared compositor preference over cached fallback, and node
  text order.
- `SmartArtEditingPlannerTests` covers regenerated cache shape roles, `dsp:sp`
  count, and cached text.
- `PptxRepairCorpusValidityTests` edits the live SmartArt corpus, regenerates the
  cache, writes and rereads PPTX, validates the package schema, and verifies the
  live layout ID and cached content.
- Focused presentation lane: 357 passed, 0 failed.
- WPF host admission/routing checks: 2 passed, 0 failed.
- Avalonia headless gallery/routing checks: 2 passed, 0 failed.

## Remaining gaps

This is renderer-neutral editable geometry, not a PowerPoint-authoritative
pixel baseline. Native effect details, exact spacing, and arbitrary unsupported
SmartArt layout variants remain outside the bounded cache/live-layout catalog.
