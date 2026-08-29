# UX visual-parity scope — 2026-08-25

## Active scope

This workstream improves user-visible parity through backed, evidence-led changes to FreeW and FreeP shell chrome, ribbon topology, adaptive layout, and already-implemented view surfaces. Each change must preserve the corresponding interaction route and be checked in a real host capture; capture availability alone is not a pixel-parity claim.

Current priority is the FreeW and FreeP ribbon/chrome surface, including command discoverability, gallery layout, responsive overflow, and existing presentation/document view modes.

## Evidence-backed residuals

- **FreeP Slide Show native-only surfaces** — Present in Teams depends on an external collaboration integration, while generic Captions & Subtitles authoring is contextual to selected media. Neither is synthesized as an inactive ribbon substitute. The backed Start Slide Show, Set Up, and Rehearse controls are now arranged in the matching task hierarchy without new dependencies.

## Explicitly deferred

- **Ink/Draw behavior** — pen, lasso, handwriting, recording, and slideshow-ink interaction fidelity are outside this stream. Existing backed behavior is not removed or represented as Word/PowerPoint-equivalent work here.
- **Map-chart fidelity** — map-chart rendering, geographic data semantics, and Office-reference visual matching are outside this stream. No synthetic map output or external geographic-data dependency will be introduced as a ribbon/chrome substitute.

These exclusions keep the current work focused on reproducible desktop chrome and backed controls. They may be planned separately when they have dedicated visual references, acceptance criteria, and any required runtime/data dependencies.
