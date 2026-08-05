# Wave 157 FreeW Manage Sources authority audit

## Compared authority surface

The pre-Wave157 WPF and Avalonia Manage Sources routes were compared directly. Both
already expose the same functional workflow through `SourceManagementDialogPlanner`:

- add, edit, and delete in the Master List and Current Document lists;
- copy in both directions, including shared conflict detection and resolution;
- double-click/double-tap editing of either selected source;
- first-item selection after initial population and planner-driven selection retention;
- default OK, cancel, and commit-on-OK behavior;
- shared persisted master-source store load/save in the owning shell route.

WPF does not expose clipboard, browse, load/save, or import/export controls in this dialog.
Those capabilities are therefore not WPF-present/Avalonia-absent parity gaps.

## Closed gap

The remaining real authority difference was the existing control sizing and presentation:

- WPF sizes the dialog to both content dimensions; Avalonia fixed it at 620 pixels wide.
- WPF lists have a 180-pixel minimum height and remain content-sized; Avalonia fixed them
  at 190 pixels.
- WPF uses 72-pixel action buttons and a real `Copy →` label; Avalonia used 84-pixel
  buttons and the ASCII label `Copy ->`.

Avalonia now follows those WPF values. No new command or source-management capability was
added to either host, and the shared planner remains the sole mutation/conflict authority.

## Evidence

- A headless Avalonia test constructs the production `ManageSourcesDialog` route and checks
  content sizing, list geometry, initial selection, exact existing controls, and OK/Cancel
  default state.
- WPF and Avalonia source guards pin the corresponding authority properties and labels.
- The Wave156 note no longer describes non-authority clipboard/file interchange as a parity
  residual.

## Verification

All focused commands ran serially with disabled build servers/shared compilation, no node
reuse, and one MSBuild node:

- `FreeW.App.Avalonia.Tests`, filters
  `ManageSourcesDialogParityTests|SourceManagementDialogPolicySourceGuardTests`: **6 passed**.
- `FreeW.App.Host.Tests`, filter `SourceManagementDialogPolicySourceGuardTests`: **4 passed**.
- `FreeW.App.Presentation.Tests`, filter `SourceManagementDialogPlannerTests`: **54 passed**.
- `git diff --check`: passed before commit.

## Residuals

The tracked visual harness currently inventories the nested WPF Manage Sources implementation
as Avalonia-only, so it cannot yet provide a paired pixel score for this route. Native toolkit
text/list rendering may still differ after the authority geometry alignment. Multi-source file
interchange would be a new cross-platform feature, not parity work, unless WPF gains it first.
