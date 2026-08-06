# FreeP SmartArt Hierarchy Action Invariants - 2026-08-06

## Scope

SmartArt text-pane Promote and Demote actions now preserve assistant ordering
across hierarchy levels. An assistant cannot be promoted to the root, and a
demoted assistant is inserted into the new parent's assistant prefix rather
than after ordinary reports. The shared model, package writer, and both host
text-pane routes therefore keep one valid hierarchy contract.

## Evidence

- `SmartArtEditingPlannerTests.Promote_AssistantToRoot_IsRejectedWithoutMutation`
  proves the invalid root transition is rejected without changing the model.
- `SmartArtEditingPlannerTests.Demote_AssistantInsertsBeforeRegularChildrenOfNewParent`
  proves assistant-prefix ordering and normalized levels after demotion.
- Focused `SmartArtEditingPlannerTests`: **156/156**.
- WPF SmartArt text-pane workflow: **1/1**.
- Avalonia SmartArt text-pane workflow: **1/1**.

This is a functional/model/package correction; it makes no PowerPoint COM or
new pixel-fidelity claim.

