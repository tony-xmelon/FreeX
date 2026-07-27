# FreeP SmartArt Quick Styles

This slice closes a functional authoring gap in the SmartArt contextual gallery.

## Scope

The shared `SmartArtAuthoringPlanner` now exposes all 14 Quick Style entries returned
by PowerPoint on this machine: Simple Fill, White Outline, Subtle Effect, Moderate
Effect, Intense Effect, Polished, Inset, Cartoon, Powder, Brick Scene, Flat Scene,
Metallic Scene, Sunset Scene, and Bird's Eye Scene. Each preset maps to the
PowerPoint quick-style identifier and updates the native diagram style part, the
editable model metadata, and the host command bus.

Both WPF and Avalonia register the same 14 commands and expose them in the SmartArt
Styles ribbon group. The existing undo/redo path remains authoritative;
the host routes do not maintain a second style state.

## Verification

- PowerPoint COM enumeration on 2026-07-28: 14 native gallery entries captured,
  including exact titles and `dgm:styleDef/@uniqueId` values. The enumeration used a
  hidden presentation containing a native SmartArt shape, then read
  `Application.SmartArtQuickStyles`.
- Presentation planner native style-part coverage: 14 cases passed.
- WPF package write/reopen coverage: 14 cases passed.
- Avalonia command plus undo/redo coverage: legacy Intense and Cartoon routes passed.
- Full FreeP Release build is required before merge.

This is functional/package parity. It does not claim that FreeP regenerates every
PowerPoint SmartArt layout/style family or matches PowerPoint's raster output; the
native cached drawing path remains authoritative for unsupported visual regeneration.
