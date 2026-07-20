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
PresentationML transition elements. It does not claim dedicated WPF/Avalonia
frame-by-frame playback for every effect: kinds without a specialized
compositor continue through the established shared fallback playback path.

## Verification

- `RibbonTransitionsAnimationsTests`: **109/109** compile-first and no-build.
- `LocTests`: **11/11**.
- `FreePRibbonDefinitionProfileTests`: **18/18**.
- `TransitionCompletenessTests`: **120/120**.
- FreeP command inventory generator: up to date; current inventory is **186**
  commands with **180** shared-profile commands.
- The unchanged `22-chart-baseline-depth` WPF render was rebuilt from the
  consuming Release artifact and remained SHA-256 byte-identical to the prior
  accepted artifact; its existing matched-reference diff remains **2.6082%**.
- No new PowerPoint COM export was issued for this authoring-only slice.

Morph playback is now a separate object-aware action; see
`freep-morph-transition-playback-20260720.md`. The other extended effects
listed above still use the established fallback playback path until their
render surfaces can support dedicated semantics.
