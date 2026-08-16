# FreeP rich-text editor: four failures uncovered by the async-void fix

`87a7f11138` ("Fix async-void Dispatch lambdas that silently swallowed test failures")
made `AvaloniaRichTextEditorTests` actually run. `HeadlessUnitTestSession` has no
`Dispatch(Func<Task>)` overload, so a valueless `async` lambda bound to the `Action`
overload, became async void, and the test returned before its assertions. Those tests
had been passing without executing.

Six failures surfaced. Two are fixed:

- **Tab past the last inline-table cell** asserted the source table grew immediately.
  The appended row is deliberately held in the editor's pending set until commit, so
  the assertion contradicted the design; it now checks the committed shape via
  `EditedBody`.
- **`HasRichFormatting`** reported false for a cell holding one bold Consolas run.
  `Runs.Count > 1 || HasMixedFormatting` misses the single-formatted-run shape, which
  still loses formatting on a plain-text round trip. Fixed in `TableCellEditPlanner`.

Four remain, all layout/geometry, none diagnosed to root cause:

| Test | Symptom |
|---|---|
| `InlineImageRun_ReservesAuthoredWidthForFollowingText` | Following text shifts 0dip; expected >20 |
| `MixedSizeWrappedLines_DriveCaretSelectionAndVerticalNavigationGeometry` | `InvalidOperationException: Covered length must be greater than zero` from `Avalonia.Media.TextFormatting.TextLineImpl.GetTextBounds` |
| `ShiftClickAndMultiClickSelectionModesRemainStable` | Double-click at `Point(32, 8)` selects "Alpha"; expected "beta" |
| `PointerDragBeyondVisibleEditor_AutoScrollsAndClampsAtDocumentEnd` | Caret row 11 where a different value was expected |

## What is already ruled out

The inline-image width machinery **exists and is wired**: `InlineImageTextRun : DrawableTextRun`
returns `Size = new Size(image.WidthDip, image.HeightDip)`, `InlineImageWidthDip` honours
`InlineImageWidthEmu`, and `TextSource.GetTextRun` returns that run at `offset == 0`. So this
is not a missing feature. The remaining suspicion is that `CreateInlineImages` produces its
layout list but those entries never reach the `_runs` collection `GetTextRun` consults --
`CreateInlineImages` swallows decode failures silently, which would leave the run as a
one-character text run and reserve no advance. That is the thread to pull first, and it is a
hypothesis, not a finding.

The two selection/caret failures hard-code pixel coordinates (`Point(32, 8)`), so they may be
sensitive to headless font metrics rather than to editor logic -- also unverified.
