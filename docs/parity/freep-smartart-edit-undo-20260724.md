# FreeP SmartArt Edit Undo Parity

## Scope

SmartArt text-pane edits in both WPF and Avalonia already used the shared outline planner,
rewrote the diagram data part, and regenerated the cached drawing. The missing PowerPoint
workflow behavior was edit history: those host paths mutated the selected `SmartArtShape`
directly, so one text edit plus its regenerated cache could not be undone or redone.

## Change

`EditingSession.EditSmartArt` now prepares an isolated SmartArt payload and commits it through
`ReplaceSmartArtCommand`. The command snapshots the complete payload, including live node data,
raw diagram parts, relationships, and fallback drawing shapes. Restore copies state into the
existing selected payload so host references remain valid. Text-pane apply, Enter sibling/child,
Tab promote/demote, and Alt+Shift move routes in both hosts use this path.

## Verification

- WPF SmartArt pane test: 1/1
- Avalonia SmartArt pane test: 1/1
- SmartArt planner tests: 26/26
- WPF host suite: 1428/1428
- Avalonia host suite: 279/280; one pre-existing brittle source assertion fails in
  `FileLifecycleWorkflowSourceTests` because it expects an older close-handler spelling.

This slice is functional parity only; it does not change SmartArt raster calibration.
