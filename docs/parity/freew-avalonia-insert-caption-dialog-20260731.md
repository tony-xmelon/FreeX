# FreeW Avalonia Insert Caption dialog

## Resolved behavior

The WPF `freew.caption` command opens an owner-modal dialog, defaults the label
to Table when the caret is in a table and Figure otherwise, accepts optional
caption text, and inserts an auto-numbered caption only after OK.

Avalonia previously registered the shared primary command and its
`freew.insert-caption` alias as inert dropdown openers. The shell now supplies
an `OpenCaptionDialog` callback with the same bounded workflow:

- Figure, Table, and Equation built-in labels are available.
- The initial label follows the caret's table context.
- Optional caption text is trimmed.
- OK inserts through the existing undoable `DocumentView.InsertCaption` route.
- Cancel, Escape, and window close leave the document unchanged.

The existing direct label menu commands are unchanged.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- Caption dialog and primary-action tests: 6/6 passed.
- Insert-depth, caption-dialog, and command-registry lane: 105/105 passed.
- The primary-action test supplies the shell callback and asserts the resulting
  Caption paragraph text (`Figure 1: Primary caption`).

No Word COM export is required for this dialog/model behavior slice.
