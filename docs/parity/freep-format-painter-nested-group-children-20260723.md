# FreeP Format Painter: Nested Group Children

## Scope

Format Painter already supported the source-then-target workflow in both WPF and Avalonia, but the shared editing session and undoable command resolved source and target IDs only against the slide's top-level shape list. Selecting a grouped child therefore left the painter inactive or rejected the hit-tested target.

The slice adds recursive shape resolution at both boundaries. Group children can now be used as the copied source, hit-tested target, and undo target without changing group membership or the existing canvas gesture paths.

## Evidence

- Shared presentation `EditingSession5ATests` Format Painter filter: 2/2 compile, 2/2 `--no-build`.
- WPF host `RibbonEditorCompleteness5BTests.Cmd_FormatPainter` filter: 2/2 compile, 2/2 `--no-build`.
- Avalonia `MainWindowHeadlessTests.Ribbon_format_painter_routes_to_editor`: 1/1 `--no-build`.

The new shared regression covers a nested source child, nested target child, fill and run-format application, and fill undo. Run-format undo remains governed by the existing command contract; this slice does not expand text-body snapshot semantics.
