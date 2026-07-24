# FreeP SmartArt Hierarchy Authoring - 2026-07-24

FreeP now exposes the two hierarchy layout paths that were already implemented by the
shared SmartArt compositor but previously available only when importing an authored deck:

- Horizontal Hierarchy
- Organization Chart

The shared authoring planner updates `dgm:layoutDef/@uniqueId`, sets the hierarchy family,
clears stale fallback shapes, and commits the mutation through the normal undo/redo bus.
WPF and Avalonia register the same commands and contextual gallery controls.

This is a functional and package-round-trip slice. PowerPoint-COM visual baseline capture
for the authoring transition remains separate evidence work.
