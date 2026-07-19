# FreeP Remaining Transition Authoring

## Scope

The shared package writer and slideshow planner already supported these
transition kinds, but the authoring ribbon did not expose them. This slice
adds typed `SetKind` commands and shared WPF/Avalonia ribbon controls for:

- Box, Doors, Reveal, Flash, and Morph
- Random Bars, Strips, and Wheel Reverse

Each command has a registered WPF icon, neutral localized label/key tip, and
planner coverage. Existing transition direction/timing preservation remains
centralized in `PresentationTransitionCommandPlanner`.

## Evidence

- Presentation transition planner: 52/52 compile-first and 52/52 no-build.
- Ribbon definition profiles: 18/18 compile-first and 18/18 no-build.
- Localization contracts: 11/11 compile-first and 11/11 no-build.
- WPF transition/animation registration: 107/107 compile-first and 107/107 no-build.
- Command inventory: 158 total, 152 shared, 0 actionable missing WPF, 0 actionable missing Avalonia.

This closes authoring access to the transition kinds already represented by the
package/playback model. It does not claim that the existing renderer-neutral
fallback playback is pixel-identical to PowerPoint for every effect.
