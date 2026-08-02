# FreeP SmartArt text-pane assistant invariants - 2026-08-02

## Functional gap

Bulk SmartArt text-pane outline replacement could bypass the individual assistant
commands' hierarchy rules. It could mark a root or a non-hierarchy node as an
assistant, or place an assistant after an ordinary report under the same parent.

## Change

The shared outline planner now rejects those invalid requests before replacing the
existing tree. Hierarchy assistants must be non-root nodes and must remain ahead of
regular reports in each sibling group. Non-hierarchy outline data cannot contain
assistant rows. Existing data, pictures, and package state remain unchanged when a
request is rejected.

## Verification

- Shared `SmartArtEditingPlannerTests`: 147/147.
- WPF `SmartArtTests`: 234/234.
- Avalonia SmartArt filter: 25/25.
- The change is shared planner behavior; no renderer calibration or visual claim is made.
