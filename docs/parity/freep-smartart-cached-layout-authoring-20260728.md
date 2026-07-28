# FreeP Cached-Only SmartArt Layout Authoring

Date: 2026-07-28

FreeP now accepts a SmartArt Layout Change when the imported graphic has a native
`diagramLayout` part but its live `SmartArtData` model is unavailable. The shared
editing session updates the native `layoutDef/@uniqueId` transactionally and keeps
the existing `dsp:drawing` fallback intact. Undo and redo restore the complete
SmartArt payload rather than only the in-memory selection.

This is a package/functionality slice. It does not claim that FreeP can regenerate
PowerPoint's layout-specific drawing cache without a live data model, nor that the
fallback raster is visually equivalent to PowerPoint after the layout change.

Verification:

- `SmartArtEditingPlannerTests` plus `EditingSessionTests`: 162/162 passed.
- WPF SmartArt host lane: 205/205 passed.
- Avalonia SmartArt host lane: 20/20 passed.
- Cached-only package write/reopen assertion verifies the native layout identity and
  fallback drawing survive the PPTX round trip.
