# FreeP extended transition authoring

## Scope

FreeP now exposes the remaining transition kinds already represented by the
model and PPTX writer through a localized `More transitions` ribbon menu:

- Fly, Random, Cube, Rotate, Flip, Ferris, Flythrough, Switch, Orbit,
  Honeycomb, Glitter, Vortex, Shred, Wind, Ripple, Warp, Fracture, Crush,
  Peel Off, Page Curl Double, Page Curl Single, Airplane, Origami, Prism,
  Curtains, Drape, and Prestige.

The commands route through `PresentationTransitionCommandPlanner`, preserving
the existing duration, direction, advance-timing, and Apply To All state.
`freep.transition.more` is a menu host only; it does not change the current
slide when the menu button itself is invoked.

## Parity boundary

This slice closes the authoring and package-function gap for these existing
PresentationML transition elements. Cube, Flip, Rotate, Honeycomb, Switch,
Orbit, Ferris, Flythrough, Glitter, Ripple, Page Curl Double, and Page Curl Single now have dedicated
shared playback actions and matching WPF/Avalonia centered two-surface
projections. The projections preserve direction, scale collapse/rotation, and
outgoing-surface participation without pretending to be a full 3-D camera.

Wind now has a dedicated shared staggered swept-band mask in both hosts; its
bands preserve direction and use a skewed leading edge rather than reducing
the transition to a fade. Curtains now has a dedicated center-out panel mask
with shared pleat geometry in both hosts. Shred now has a dedicated
interleaved fragment mask with diagonal torn edges. Peel Off now uses the
shared single-fold page-peel projection. Drape now has a dedicated segmented
wave-front mask. Airplane now uses the direction-aware Flythrough projection.
Origami now uses the shared double-fold page projection.
Vortex now has a dedicated radial-spiral sector mask.
Warp now has a dedicated segmented elastic-front mask.

Morph is a separate object-aware action. The remaining effects listed above
are the shape-deforming families; they do not yet have dedicated frame-by-frame
playback and continue through the
established shared fallback path.

## Verification

- `RibbonTransitionsAnimationsTests`: **109/109** compile-first and no-build.
- `LocTests`: **11/11**.
- `FreePRibbonDefinitionProfileTests`: **18/18**.
- `TransitionCompletenessTests`: **124/124** for the focused transition and
  host-policy filter.
- FreeP command inventory generator: up to date; current inventory is **186**
  commands with **180** shared-profile commands.
- The unchanged `22-chart-baseline-depth` WPF render was rebuilt from the
  consuming Release artifact and remained SHA-256 byte-identical to the prior
  accepted artifact; its existing matched-reference diff remains **2.6082%**.
- No new PowerPoint COM export was issued for this transition-function slice.

Morph playback is an object-aware action; see
`freep-morph-transition-playback-20260720.md`. The Cube/Flip/Rotate projection
details and focused verification are recorded in
`freep-perspective-transition-playback-20260720.md`; Honeycomb is recorded in
`freep-honeycomb-transition-playback-20260720.md`.
