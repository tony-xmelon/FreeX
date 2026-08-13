# FreeW shared revision resolution (2026-08-13)

## Gap closed

FreeW previously had three different tracked-change mutation paths:

- WPF accepted and rejected revisions by mutating `TrackChanges` / `RevisionList` directly, outside the
  shared undo history.
- Avalonia ribbon actions used renderer-local undo commands.
- Avalonia Reviewing Pane buttons bypassed those commands and mutated the model directly.

The renderer-local Avalonia snapshot also covered only paragraph runs. It could not correctly undo bulk
resolution that merges or removes paragraphs, removes tracked table rows, or reaches nested tables.

## Shared authority

`FreeW.Core.Model.RevisionResolutionCoordinator` is now the one entry point for Accept, Reject, Accept All,
and Reject All. It rejects stale/no-op reviewing entries before they enter history, and dispatches shared
`RevisionResolutionCommand` implementations through `DocumentCommandBus`.

Bulk undo snapshots cover every structure `TrackChanges` can mutate: document block membership, table-row
membership and row revision metadata, cell paragraph membership, nested tables, paragraph-mark and
paragraph-format revisions, and run membership/revision/formatting metadata. Single-entry actions retain a
focused paragraph snapshot instead of copying the whole document body.

WPF and Avalonia now keep only host synchronization and selection concerns:

- WPF commits pending native editor state, then calls the shared coordinator.
- Avalonia ribbon commands and Reviewing Pane row/header buttons call the same coordinator through
  `DocumentView`.
- Both hosts redraw from their existing `DocumentCommandBus.Changed` subscriptions.

## Managed evidence

`RevisionResolutionCommandTests` covers:

- single accept and reject with undo/redo and original-object identity;
- tracked-format rejection and restoration;
- stale and foreign entry rejection without undo-history pollution;
- paragraph-mark merge undo/redo;
- nested-table row removal and table-cell paragraph removal undo/redo;
- no-op bulk actions without history entries.

The focused Core.Model test lane and compile-only WPF/Avalonia project builds pass. Per the machine-level
constraint, no UI, app-startup, capture, screenshot, or headless-Avalonia test lane was run.
