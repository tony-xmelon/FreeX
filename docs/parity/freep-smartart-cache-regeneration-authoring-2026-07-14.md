# FreeP SmartArt Cache-Regeneration Authoring Evidence - 2026-07-14

This slice deepens the remaining SmartArt text-pane/cache-regeneration authoring
gap with a bounded shared cache rewrite path.

## Scope

- `SmartArtEditingPlanner` can regenerate a deterministic `dsp:drawing` cache
  part from the same shared live-layout plan consumed by WPF and Avalonia.
- The cache rewrite currently covers supported auto-shape SmartArt layouts such
  as hierarchy/process/list/cycle/matrix families; picture-backed cache
  regeneration remains deferred.
- Regeneration updates the in-memory fallback shapes and the raw
  `ppt/diagrams/drawing*.xml` bytes that the existing PPTX writer persists.

## Honesty Bound

This is a no-COM authoring/cache readiness slice. It proves host-neutral cache
bytes can be regenerated after shared outline edits, but it does not claim
PowerPoint-authoritative visual parity, full SmartArt text-pane UI parity,
PowerPoint exact auto-layout, or layout/style/color part regeneration.

## Evidence

- `SmartArtEditingPlannerTests.RegenerateDrawingCache_AfterSharedOutlineEdit_RewritesDspDrawingFromLivePlan`
  proves an edited shared hierarchy outline rewrites deterministic `dsp:drawing`
  XML and refreshes fallback shapes from the shared planner.
- `SmartArtTests.RoundTrip_SmartArt_SharedDrawingCacheRegenerationPersistsEditedOutline`
  proves the regenerated cache is saved into the PPTX package and reread as the
  edited SmartArt drawing cache.

## Remaining Work

PowerPoint-authoritative visual baselines, full host text-pane workflows,
keyboard routing, broader picture/media-backed cache regeneration, and exact
PowerPoint layout/style/color regeneration remain open.
