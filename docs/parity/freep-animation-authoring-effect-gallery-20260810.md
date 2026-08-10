# FreeP Animation Authoring Effect Gallery

## Scope

The shared animation command planner now authors the standard entrance and exit effects that were already supported by imported-animation playback but were missing from the authoring gallery:

- Dissolve and Flash
- Crawl and Peek
- Spiral and Swivel
- Bounce and Float
- Swoop and Boomerang

Each effect is exposed in the advanced entrance/exit menus for both WPF and Avalonia. The command creates the typed `AnimationKind`/`AnimationPreset` pair through the shared planner, so native save/reopen, undo, and slideshow playback use the same semantic payload on both hosts.

## Verification

- Presentation command planner: 120 focused tests passed.
- WPF ribbon registration: 146 focused tests passed.
- Ribbon definition profile: 24 tests passed.
- Localization resource coverage: 11 tests passed.
- Presentation, ribbon, host, and localization Release builds: 0 warnings, 0 errors.
- Generated FreeP command inventory: 688 shared commands, 0 actionable host gaps.

This is a functional authoring slice; no raster comparison was used because the playback paths were already established and unchanged.
