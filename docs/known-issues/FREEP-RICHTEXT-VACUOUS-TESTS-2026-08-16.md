# FreeP rich-text editor: four failures uncovered by the async-void fix

## Status

**RESOLVED.** All six are fixed; `FreeP.App.Rendering.Avalonia.Tests` is 275/275.

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

**All six are now fixed.** The suite passes 275/275.

Four were defects in shipping code, not test drift:

- **Wrapped-line caret X.** Every caret X came from `Layout.HitTestTextPosition`, but at a wrap
  boundary that position belongs to both lines and the paragraph layout resolves it to the next
  one -- so a wrapped line's last caret reported the *following* line's left edge. Vertical
  navigation carried that X downward and landed back on the same position. Measured: preferred X
  4 (identical to position 0) instead of 72.5.
- **`BuildSelectionRects` threw out of `Render`.** `GetTextBounds` rejects ranges its runs cannot
  cover; a drag past the document end reaches one. In production that tears down the visual tree
  over a selection highlight.
- **Drag past the end never selected to the end.** The endpoint is hit-tested from the pointer,
  which has nothing to resolve toward once scrolling is exhausted, so it stopped 16 characters
  short. Now clamps -- guarded on the content being scrollable, since a document that fits the
  viewport also stops advancing and must keep ordinary drag behaviour.
- **`HasRichFormatting`** reported false for a cell holding one bold Consolas run;
  `Runs.Count > 1 || HasMixedFormatting` structurally cannot see that shape.

Two were test drift: `CaretRect` read before focus and drain (making an inline-image comparison
0 - 0), and an appended inline-table row asserted on the source table before the pending set was
committed. Two more assumed fixed geometry -- a hard-coded click pixel and a fixed auto-scroll
iteration count -- and now derive both from the actual layout.

---

## Original notes

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
