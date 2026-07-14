# FreeP SmartArt Text-Pane Keyboard Routing Evidence - 2026-07-14

This slice advances SmartArt text-pane workflow depth with a shared keyboard
route planner that WPF and Avalonia host adapters can consume without
PowerPoint COM.

## Scope

- `SmartArtEditingPlanner.PlanTextPaneKeyboardRoute` maps bounded text-pane
  chords to existing shared SmartArt edit intents.
- Covered routes are Enter for add sibling, Ctrl+Enter for add child, Tab for
  demote, Shift+Tab for promote, and Alt+Shift+Up/Down for row reordering.
- The planner trims and validates the selected model id, rejects unowned
  chords, and keeps all mutations in the existing shared
  `SmartArtNodeEditIntent` path.
- WPF and Avalonia can bind their text-pane controls to the same route table
  instead of carrying renderer-local SmartArt keyboard policy.

## Honesty Bound

This is no-COM shared planner evidence. It does not claim a completed host
text-pane control, PowerPoint-authored authoring baselines, exact PowerPoint UI
chrome, or PowerPoint-authoritative visual baselines.

## Evidence

- `SmartArtEditingPlannerTests.PlanTextPaneKeyboardRoute_MapsSharedChordsToEditIntents`
  pins the cross-host chord-to-intent table.
- `SmartArtEditingPlannerTests.PlanTextPaneKeyboardRoute_RejectsUnownedChordsAndMissingSelection`
  proves unsupported chords and missing selections do not create host-local
  fallback behavior.
- `SmartArtEditingPlannerTests.PlanTextPaneKeyboardRoute_FeedsSharedModelEditsForHostAdapters`
  applies routed add-child, reorder, and demote intents to the shared SmartArt
  model, proving host adapters can use the route table as executable workflow
  evidence.

## Remaining Work

PowerPoint-authored authoring baselines, real host text-pane controls, richer
assistant/org-chart editing nuance, broader picture/media-backed cache
regeneration, exact PowerPoint layout/style/color regeneration, and
PowerPoint-authoritative visual baselines remain deferred.
