# Avalonia parity wave 53: FreeW text-box paragraph editing

Date: 2026-07-29

## Chosen gap

The live FreeW evidence and Wave 52 source audit showed that Avalonia could enter
only the first paragraph/run of a floating text box. Enter did not create a
WordprocessingML paragraph; it re-entered the selected shape. The existing
single-run command also left the owning drawing run's plain-text fallback stale
after an edit. WPF's native text-box surface remains the authority for
multiline text-box editing and paragraph-boundary undo behavior.

## Implemented

- Enter in selected text-box edit mode inserts a real shape text paragraph
  through the shared command bus.
- Backspace at the start of a shape paragraph merges it with the previous
  paragraph through an undoable shared command.
- Shape text run edits, paragraph splits, and paragraph merges synchronize the
  outer drawing run's plain-text fallback used by document summaries and
  consumers that do not inspect the shape body.
- The existing caret address now advances to the new paragraph/run after Enter
  and returns to the previous paragraph after a merge.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewFloatingShapeTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed 20/20.
- The focused regression covers paragraph split, text insertion, undo/redo,
  paragraph merge, and outer-run mirror synchronization.

## Linux evidence boundary

The existing FreeW Linux physical lane proves seeded document editing and table
pagination, but does not seed/select a floating text box or provide a stable
contextual text-box edit route. This slice therefore uses deterministic
Avalonia headless interaction coverage; the family Linux physical contract
remains unchanged.

## Remaining FreeW gaps

Shape text still needs richer run formatting and direct pointer caret placement;
grouped-child local move/resize, edit-points path selection, and nested-group
editing remain separate slices from Wave 52.
