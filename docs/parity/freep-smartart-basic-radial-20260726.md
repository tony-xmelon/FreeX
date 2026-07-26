# FreeP SmartArt Basic Radial - 2026-07-26

This slice makes PowerPoint's native `radial1` (Basic Radial) layout an editable
live SmartArt layout in FreeP. Previously the reader classified `radial1` as a
cycle family but kept the cached drawing because it was absent from the live
layout allow-list.

## Function coverage

- `SmartArtAuthoringPlanner` can select the native
  `urn:microsoft.com/office/officeart/2005/8/layout/radial1` layout.
- The shared layout engine emits a central topic ellipse, one spoke box per
  remaining node, and a connector from the topic to each spoke.
- WPF and Avalonia expose the same undoable ribbon command:
  `freep.smartart.layout.basic-radial`.
- The package reader admits `radial1` as live-layout supported, while the native
  diagram part remains the serialization authority.

## Evidence

- Presentation tests cover native layout selection and hub-and-spoke geometry.
- WPF Host tests cover package read/live-layout admission and ribbon routing.
- Avalonia headless tests cover command registration, execution, and undo.

This is functional shared-layout coverage, not a claim of PowerPoint-identical
SmartArt auto-layout or pixel-level geometry.
