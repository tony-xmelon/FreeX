# FreeP advanced animation effect command symmetry

## Scope

The Animations ribbon now exposes the renderer-supported mask families through
two compact dropdowns: advanced entrance effects and advanced exit effects.
The visible controls use `Blinds In` and `Blinds Out` as their primary actions;
their menus expose Checkerboard, Box, Circle, Diamond, Plus, Strips, Wedge,
Wheel, and Random Bars variants.

Every menu command is backed by the shared `PresentationAnimationCommandPlanner`
and the existing WPF/Avalonia playback plans. No host-specific effect mapping
or new animation approximation was introduced in this slice.

## Verification

- `PresentationAnimationCommandPlannerTests`: 52/52 compile-first and no-build
- `LocTests`: 11/11 compile-first and no-build
- `FreePRibbonDefinitionProfileTests`: 18/18 compile-first and no-build
- `RibbonTransitionsAnimationsTests`: 94/94 compile-first and no-build
- Generated command inventory and cross-app dashboard refreshed

The advanced commands are authoring-surface parity; PowerPoint-authoritative
animation-pane and frame-by-frame visual baselines remain a separate evidence
requirement.
