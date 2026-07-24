# FreeP SmartArt Picture Caption List authoring

FreeP now exposes the existing `pictureCaptionList` live-layout capability as a
shared authoring command in both WPF and Avalonia:

- `freep.smartart.layout.picture-caption-list` updates the native
  `dgm:layoutDef/@uniqueId` and the live model family through the shared
  `EditingSession` undo path.
- The command is available only when every SmartArt node has non-empty image
  bytes. Without that payload the planner returns a non-applied result instead
  of claiming a live layout that would silently fall back to cached drawing.
- Native package persistence, WPF/Avalonia command registration, and the
  generated command inventory are covered by focused tests.

This is functional authoring parity for the bounded image-bearing route. It
does not claim PowerPoint-authoritative picture selection UI, broader picture
layouts, or visual-baseline parity.
