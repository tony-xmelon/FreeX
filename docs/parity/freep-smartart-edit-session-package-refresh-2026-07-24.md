# FreeP SmartArt Edit-Session Package Refresh Evidence - 2026-07-24

This slice closes a shared API consistency gap in SmartArt authoring.

## Scope

- `EditingSession.ApplySmartArtLayout` now rewrites the native diagram data part
  and regenerates the drawing cache before committing the undoable edit.
- `EditingSession.ApplySmartArtQuickStyle` uses the same package-refresh route.
- `EditingSession.ApplySmartArtColor` exposes the shared Change Colors route and
  refreshes the same native package/cache state.
- WPF and Avalonia host-specific SmartArt paths remain compatible; this change
  strengthens the shared session API used by non-host callers and persistence
  workflows.

## Evidence

- `EditingSessionTests.ApplySmartArtLayout_RefreshesNativeDataAndDrawingCacheThroughSharedSession`
  proves the public shared layout route leaves an undoable edit with regenerated
  fallback shapes and non-empty native data/cache payloads.
- Focused `SmartArtEditingPlannerTests` and `EditingSessionTests` pass together.

## Honesty Bound

This is functional package-state parity, not a claim of PowerPoint-authoritative
SmartArt geometry or exact layout/style/color rendering. Picture/media-backed
cache regeneration and native PowerPoint visual baselines remain deferred.
