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

Two more were fixed after the first pass:

- **`HasRichFormatting`** reported false for a cell holding one bold Consolas run;
  `Runs.Count > 1 || HasMixedFormatting` structurally cannot see that shape. Fixed in
  `TableCellEditPlanner`.
- **`InlineImageRun_ReservesAuthoredWidthForFollowingText`** read `CaretRect` with no
  focus and no input drain, so both reads returned the same stale rect and their
  difference was 0 - 0. The inline-image width machinery was never at fault.

Three remain, all caret/hit-test geometry:

| Test | Symptom |
|---|---|
| `MixedSizeWrappedLines_DriveCaretSelectionAndVerticalNavigationGeometry` | `InvalidOperationException: Covered length must be greater than zero` from `Avalonia.Media.TextFormatting.TextLineImpl.GetTextBounds` |
| `ShiftClickAndMultiClickSelectionModesRemainStable` | Double-click at `Point(32, 8)` selects "Alpha"; expected "beta" |
| `PointerDragBeyondVisibleEditor_AutoScrollsAndClampsAtDocumentEnd` | Caret row 11 where a different value was expected |

## What is already ruled out

**Layout is running.** In `MixedSizeWrappedLines`, the assertion immediately before the failure
(`caret.Height > 25`, sourced from the 28pt run) passes, so the editor has focus, input has
drained, and the text layout reflects the real runs. The failure is not a missing measure pass.

**Vertical navigation is reaching the boundary branch.** `InCanvasRichTextNavigationPlanner`
returns the caret unchanged when `targetLine >= lines.Count`, which is exactly the observed
`down == 11`. So `FindVerticalLine` is placing logical position 11 on the *last* visual line,
even though `EvidenceBody` has a second paragraph ("Centered numbered paragraph") that must
occupy a line below it. The next step is to instrument `BuildVisualLineGeometry()` and count the
lines it produces: either it omits the second paragraph, or the per-line logical ranges put
position 11 past the end. That is the thread to pull, and it is a hypothesis, not a finding.

**The inline-image machinery is exonerated**, and the earlier suspicion about
`CreateInlineImages` swallowing decode failures was wrong: `InlineImageTextRun : DrawableTextRun`
returns the authored size, `InlineImageWidthDip` honours `InlineImageWidthEmu`, and
`TextSource.GetTextRun` returns that run at `offset == 0`. The test was simply measuring before
the caret had settled.

The two selection failures hard-code pixel coordinates (`Point(32, 8)`), so they may be sensitive
to headless font metrics rather than to editor logic -- unverified.
