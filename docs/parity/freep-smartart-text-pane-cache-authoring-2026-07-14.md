# FreeP SmartArt Text-Pane Cache Authoring Evidence - 2026-07-14

This slice advances the remaining SmartArt text-pane/cache-regeneration
authoring gap with a bounded shared outline batch workflow.

## Scope

- `SmartArtEditingPlanner.ApplyTextPaneOutline` applies an ordered text-pane
  outline to the shared `SmartArtData` model transactionally.
- Outline rows carry text, level, optional assistant state, and optional stable
  model ids so WPF and Avalonia can route text-pane edits without host-local
  SmartArt tree policy.
- Existing `RewriteDataPart` and `RegenerateDrawingCache` consume the applied
  shared model, producing native diagram-data bytes plus deterministic
  `dsp:drawing` cache bytes from the same evidence path.
- Stable node ids are preserved when supplied or positionally reusable, and
  existing picture payloads stay attached to matching model ids for bounded
  picture-backed text edits.

## Honesty Bound

This is a no-COM shared authoring/cache readiness slice. It does not claim
PowerPoint-authoritative visual parity, exact PowerPoint text-pane keyboard
behavior, full host text-pane UI parity, exact SmartArt auto-layout, or
regeneration of layout/style/color parts.

## Evidence

- `SmartArtEditingPlannerTests.ApplyTextPaneOutline_RebuildsSharedTreeAndLiveLayout`
  proves ordered text-pane rows rebuild the shared hierarchy model, including
  assistant state, and feed the same live layout consumed by WPF/Avalonia.
- `SmartArtEditingPlannerTests.ApplyTextPaneOutline_SkippedParentLevelIsRejectedWithoutMutation`
  proves invalid skipped-level outlines are rejected without mutating the
  existing SmartArt model.
- `SmartArtEditingPlannerTests.ApplyTextPaneOutline_PreservesPicturePayloadsByStableNodeId`
  proves stable model ids keep bounded picture payloads attached through
  text-pane reordering.
- `SmartArtEditingPlannerTests.TextPaneOutline_DataPartAndDrawingCacheRegenerationShareAppliedModel`
  proves native data-part and drawing-cache regeneration consume the same
  text-pane-applied shared model.
- `SmartArtTests.RoundTrip_SmartArt_TextPaneOutlineRegeneratesDataPartAndDrawingCache`
  proves the existing PPTX writer persists both regenerated parts and the
  reader rebuilds the edited hierarchy plus fallback cache from the saved deck.

## Remaining Work

PowerPoint-authored authoring baselines, real host text-pane controls, keyboard
shortcut parity beyond the shared planner, richer assistant/org-chart editing
nuance, broader picture/media-backed cache regeneration, exact PowerPoint
layout/style/color regeneration, and PowerPoint-authoritative visual baselines
remain deferred.
