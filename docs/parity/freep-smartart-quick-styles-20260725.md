# FreeP SmartArt Quick Styles

This slice closes a functional authoring gap in the SmartArt contextual gallery.

## Scope

The shared `SmartArtAuthoringPlanner` now exposes eight curated native Quick Style
presets: Simple, Moderate, Intense, Subtle, Soft Edge, Insert, Cartoon, and Powder.
Each preset maps to its Office quick-style identifier and updates the native diagram
style part, the editable model metadata, and the host command bus.

Both WPF and Avalonia register the same five newly added commands and expose them in
the SmartArt Styles ribbon group. The existing undo/redo path remains authoritative;
the host routes do not maintain a second style state.

## Verification

- Presentation planner native style-part coverage: 8 cases passed.
- WPF package write/reopen coverage: 8 cases passed.
- Avalonia Cartoon command plus undo/redo: 1 case passed.
- Full FreeP Release build is required before merge.

This is functional/package parity. It does not claim that FreeP regenerates every
PowerPoint SmartArt layout/style family or matches PowerPoint's full style gallery.
