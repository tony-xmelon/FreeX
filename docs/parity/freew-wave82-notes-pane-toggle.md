# FreeW Wave 82: Notes Pane Toggle State

## Scope

This slice compares the WPF and Avalonia `freew.show-notes` route behind the References > Footnotes command. It covers the existing stateful pane workflow and excludes Reviewing Pane sort, imported line-spacing/run-default work, and visual-only Word-baseline gaps.

## Finding

Avalonia already constructed and docked the editable `NotesPane`, and `MainWindow` supplied both `ToggleNotesPane` and `IsNotesPaneVisible` callbacks. Its ribbon registration wrapped the toggle as a plain `ActionRibbonCommand`, so the command could open or close the pane but could not expose the live checked state to the ribbon renderer.

WPF used a stateful toggle for the same route. Before this change, the two hosts therefore differed in a user-visible way: the Avalonia References control did not remain checked while the notes pane was visible.

## Change

`FreeWStatefulToggleCommand` now lives in shared FreeW presentation logic. Both hosts use it for the callback-backed `freew.show-notes` route; WPF also retains its existing pre-toggle model commit through the shared adapter. Avalonia now reports `IsChecked` from `IsNotesPaneVisible` and follows both open and close transitions.

## Evidence

- WPF: `FreeWRibbonParityTests.ShowNotes_WithPaneCallbacks_IsBackedStatefulToggle` verifies checked, unchecked, open, and close states.
- Avalonia: `ReferencesTabTests.ShowNotes_with_pane_callbacks_exposes_live_checked_state` verifies the same state transitions.
- The route is implemented through the existing live pane callbacks, not a visual-only or inventory-only change.
