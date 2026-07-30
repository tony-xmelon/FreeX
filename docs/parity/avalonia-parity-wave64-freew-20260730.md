# Wave 64 FreeW nested grouped-child text editing

Date: 2026-07-30
App scope: FreeW only

## Implemented

- Added an optional nested `ChildPath` to the shared shape-text edit commands:
  `SetShapeTextRunCommand`, `ReplaceShapeTextParagraphsCommand`,
  `InsertShapeTextParagraphBreakCommand`, and
  `MergeShapeTextParagraphWithPreviousCommand`.
- Nested commands resolve the leaf through `DrawingGroupChildPathResolver`, mutate only that leaf,
  preserve the native group graph, and do not flatten text into the outer drawing run.
- Avalonia now enters text editing for selected grouped text-bearing shapes, including nested paths;
  grouped shape layouts build path-aware caret stops and pointer hit-testing inverse-composes the
  existing child and parent transforms.
- Text insertion, range replacement, paragraph split/merge, backspace/delete, undo/redo, and the
  existing character-formatting route use the active child path. F2 and the second click on an
  already-selected text-bearing grouped shape are explicit entry routes.
- Added paired managed evidence for the shared WPF/Avalonia command semantics and a DOCX fixture mode
  for a nested text leaf.
- Added the dedicated Linux/X11 probe, validator, and schema under `tools/`.

## Verification

Passed:

- `FreeW.Core.Model.Tests`: `ShapeTextCommands` filter, 2 tests.
- `FreeW.App.Avalonia.Tests`: `Nested_grouped_text_box_supports_composed_caret_editing_and_path_undo`.
- `FreeW.App.Host.Tests`: `NestedGroupedShapeTextParityTests`.
- Focused Avalonia and fixture Release builds: 0 warnings, 0 errors.
- Fixture DOCX generation and read-back: nested path `0,1`, text paragraphs/runs, and group transforms preserved.

Linux physical evidence:

- The owned container started and was stopped cleanly at `1280x820`, `96 DPI` on port `6094`.
- A manual X11 pass using the normal `Return` entry route selected the nested leaf, inserted text,
  saved it, and produced a host-side DOCX whose nested leaf read `Nested leaf\n!`; group transforms
  and native nested structure remained intact.
- The dedicated scripted probe captured the selection screenshots but did not persist the insertion
  in its click/timing path, so the exact validator remained red. The validator correctly failed rather
  than promoting a false pass. This is now narrowed to probe focus/timing, not the managed
  path-aware command behavior or DOCX writer/reader.

## Residual

- Align the scripted probe's focus/settling sequence with the successful manual X11 sequence, then
  rerun the validator to obtain the saved/reopened `Nested leaf!` manifest.
- Full end-to-end DOCX save/reopen through the physical lane is therefore not yet proven.
