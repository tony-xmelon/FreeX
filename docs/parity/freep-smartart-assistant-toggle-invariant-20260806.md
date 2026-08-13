# FreeP SmartArt Assistant Toggle Invariant - 2026-08-06

## Scope

The shared SmartArt text-pane edit route now keeps hierarchy assistants in a
leading sibling block when a node is toggled. Enabling assistant status moves
the node before ordinary reports; disabling it moves the node immediately
after the existing assistant prefix. The edit remains one undoable shared
model/package operation through the existing WPF and Avalonia host adapters.

## Why this is functional parity

The previous toggle changed only `SmartArtNode.IsAssistant`, so a regular
report after another report could become an assistant after the regular-report
block. That state contradicted the text-pane outline rule and serialized an
invalid assistant ordering even though the command reported success. The
planner now enforces the same ordering invariant used by outline import and
assistant insertion.

## Evidence

- `SmartArtEditingPlannerTests.ToggleAssistant_MovesNodeAcrossAssistantPrefixAndPreservesPackageOrder`
  proves enable/disable ordering and `dgm:pt/@type="asst"` package output.
- Focused `SmartArtEditingPlannerTests`: **154/154**.
- No PowerPoint COM or pixel-fidelity claim is made by this slice; it is a
  shared model, text-pane, undo, and package-semantics correction.
