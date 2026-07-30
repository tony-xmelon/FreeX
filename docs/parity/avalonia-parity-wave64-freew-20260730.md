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

- The owned containers started and were stopped cleanly at `1280x820`, `96 DPI` on port `6094`.
- The deterministic probe selects the nested child once, sends one `Return` entry key, types `!`,
  saves, stops/restarts, and captures the reopened document.
- `Run-FreeWWave64NestedTextValidation.ps1` is green with a 4/4 manifest:
  `Nested leaf` -> `Nested leaf!` -> `Nested leaf!` after reopen.
- The native child path remains `0,1`, the leaf remains a `Shape`, and both outer/inner transforms are
  unchanged.

## Residual

- No Wave 64-specific residual remains for the bounded nested grouped-child text contract.
