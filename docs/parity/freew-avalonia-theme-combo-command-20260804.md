# FreeW Avalonia theme combo command parity (2026-08-04)

## Gap

The shared Avalonia ribbon renderer sends a combo selection through
`RibbonCommandContext.SelectedValue`. The Design `freew.theme` control was registered as a no-op
dropdown opener, so choosing a theme from the compiled combo did not change the document. Existing
per-theme menu command ids worked, which hid the live combo route gap.

## Change

`freew.theme` now uses a stateful command, resolves the selected name through
`DocumentTheme.FindByName`, and calls the existing undoable `DocumentView.ApplyTheme` path. Its state
reads `Document.Theme.Name`, allowing ribbon refresh to publish the current theme from newly created,
edited, undone, and loaded documents. Existing `freew.theme.<name>` menu commands are unchanged.

## Behavior

- Selecting `Berlin` from the top-level combo applies the Berlin theme.
- Undo restores the prior `Office` theme.
- A freshly loaded `Ion` document publishes `Ion` without executing the command.
- Unknown, null, and empty selected values are no-ops.
- The existing `freew.theme.berlin` menu command remains covered as a control.

## Verification

- `DesignTabTests`: 29/29 compiling focused run.
- The focused build compiled `FreeW.App.Avalonia` and its test assembly successfully.

## Process rule

Profile inventory and per-item menu coverage do not prove a value-bearing combo route. Execute the
top-level command with the exact renderer `SelectedValue` context and retain a per-item command control.
