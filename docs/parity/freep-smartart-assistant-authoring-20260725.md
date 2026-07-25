# FreeP SmartArt Assistant Authoring - 2026-07-25

FreeP now exposes the PowerPoint-style assistant designation for hierarchy SmartArt in both
WPF and Avalonia text panes. The selected non-root row can be toggled with **Toggle Assistant**.

The action is owned by the shared `SmartArtEditingPlanner` and `EditingSession` path:

- hierarchy nodes toggle `SmartArtNode.IsAssistant`;
- the native data part is rewritten with `dgm:pt type="asst"` (or `node` when disabled);
- the live drawing cache is regenerated through the existing hierarchy layout engine;
- the whole mutation is one undoable command;
- root nodes and non-hierarchy SmartArt are rejected with an explicit result.

Both hosts refresh the text pane and canvas after the edit. Existing assistant nodes remain
round-trip safe, and this slice intentionally does not broaden PowerPoint's assistant-specific
org-chart layout styling beyond the existing shared hierarchy engine.

## Verification

- Presentation SmartArt planner tests: 77 passed.
- WPF SmartArt text-pane host tests: 2 passed.
- Avalonia SmartArt text-pane headless tests: 2 passed.
