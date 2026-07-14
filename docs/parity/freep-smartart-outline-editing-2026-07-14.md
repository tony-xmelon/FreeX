# FreeP SmartArt Outline Editing Evidence - 2026-07-14

This slice extends FreeP's shared SmartArt authoring model with deterministic
outline editing operations that both WPF and Avalonia can consume without
renderer-local SmartArt policy.

## Scope

- `SmartArtEditingPlanner` now supports moving nodes up/down within a sibling
  outline, promoting a node to its parent's sibling level, and demoting a node
  under its previous sibling.
- The planner preserves stable selected-node ids, rebuilds outline evidence,
  and normalizes levels after every structural edit.
- Shared live-layout planning consumes the mutated `SmartArtData`, so WPF and
  Avalonia receive the same refreshed shape/connector plan.

## Honesty Bound

This is model/planner evidence for no-COM SmartArt authoring parity. It does
not rewrite the native PowerPoint diagram data parts yet, expose a complete
SmartArt text pane UI, claim keyboard-shortcut parity, or provide a
PowerPoint-authoritative visual baseline.

## Evidence

- `SmartArtEditingPlannerTests` covers text edit, add/remove, outline
  reorder, promote, demote, invalid boundary cases, stable selection, and
  live-layout refresh after structural edits.
- The implementation stays in shared FreeP presentation code; WPF and
  Avalonia can consume the same model mutations and resulting compositor plan.

## Remaining Work

PowerPoint-native data-part rewriting, host UI affordances, keyboard and text
pane workflows, assistant/org-chart branch editing nuance, and
PowerPoint-authoritative authoring/visual baselines remain deferred.
