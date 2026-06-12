# FreeX Comprehensive Code Review - 2026-06-11

## 0. Method And Coverage

Fresh full-workspace review run on `worker-c-cf-aggregate-list-parity` at HEAD `0a7777100` ("Add CF aggregate list formula parity"). The working tree carried one unrelated session-owned change (`tests/FreeX.Core.IO.Tests/XlsxNonChartSchemaValidationTests.CustomXml.cs`) that was left untouched. `main` advanced to `8abbf3406` during the review; final verification ran against `main` in an isolated worktree, and every P1 finding's source anchor was re-confirmed present on that `main` HEAD.

Scope covered:

- `src/`: all seven projects (Core.Model, Core.Formula, Core.Calc, Core.Commands, Core.IO, App.Host, App.UI), ~2,100 C# files.
- `tests/`, `tools/`, `.github/workflows/`, release scripts, solution/build configuration, and docs spot-checks.

Review method:

- Seven independent finder passes: formula/calc correctness, Core.IO correctness/hardening, model/command invariant tracing (Execute/Revert symmetry), App.Host/App.UI stability and threading, hot-path performance, reuse/consistency/duplication, and architecture/altitude/gaps.
- Line-by-line audit of the four most recent merges (`9cf750817`, `e8add9d6b`, `5f39d13e9`, `0a7777100`) including a removed-behavior check; all four are clean.
- Independent source re-verification of every P1 and the highest-impact P2 candidates (quoted lines re-read in context, callers traced). Findings marked "verified" below were re-confirmed this way; the remainder rest on the finder pass's quoted evidence.
- Confirmation that all 2026-06-03 review fixes are present in `main` (stream caps, secure XML loads, lexer bounds, INDIRECT clamp, UIA peers, tester-release concurrency/signing, tool-project solution coverage).

## 1. Executive Summary

The build, default test lane, and repository preflight are green (section 8). Layering is clean (no Core→App references, no WPF types in Core), the recent schema-sanitization merges are sound, and the undo system is mostly impressively symmetric.

The dominant theme this cycle is **data integrity at the edges of otherwise-good infrastructure**:

1. **The save pipeline races user input.** Save serializes the *live* workbook on a thread-pool thread while the window stays fully interactive, then unconditionally marks the workbook clean — edits made mid-save can be torn or silently dropped, including in the save-on-close flow.
2. **Two commands bypass the shared shift/rewrite infrastructure.** Remove Duplicates deletes whole sheet rows for a partial-range selection, and Insert/Delete Cells shifts raw cells with no formula rewrite or metadata adjustment.
3. **Blank-cell comparison semantics diverge from Excel** in the comparison operators (`=A1=0` is FALSE for blank A1), a high-frequency formula pattern.
4. **There is no autosave or crash recovery** — crash handlers record diagnostics and let all unsaved work die.
5. **Save-side feature failures are silent**: one bad defined name drops *all* named ranges with only a `Debug.WriteLine`.

Performance findings concentrate on the keystroke/scroll path (conditional-format aggregate rescans per viewport rebuild, an O(dirty²) recalc-ordering loop). Consistency findings identify six independent `QuoteSheetName` implementations with three divergent predicates — two of which write broken references into saved files — and a family of re-implemented A1 parsers. Architecture findings flag the per-element XLSX sanitizer treadmill and the 53-file / 26.5-KLOC MainWindow god object.

### Resolution update - 2026-06-12 follow-up

Twenty of the findings below were fixed and merged to `main` on 2026-06-12 through sixteen `fix/*-20260612` branches plus two integration corrections. Resolved: all five P1s (save-race generation guard + input blocking + close re-check, range-scoped Remove Duplicates, Insert/Delete Cells formula rewrite + merge guard + metadata shift, blank comparison coercion, autosave/crash recovery with startup restore); the P2 correctness set (per-item save warnings surfaced to the host, patch-save XML escaping with full-save fallback, RemoveSheet `#REF!` rewrite, approximate-lookup type skipping + `CompareScalar` ordering, ROUNDDOWN/ROUNDUP/TRUNC decimal correction, text-coercion gating, CF blank-duplicate handling, Sort/Autofill/DV-cache undo fidelity, async export with atomic writes and XPS leak fix); the top perf items (CF context cache keyed on content/CF versions, candidate-indexed recalc ordering, HashSet dependents); the `QuoteSheetName` consolidation into `SheetNameFormatter`; the CI gap (PR lane now builds `FreeX.slnx`, workflow concurrency, UI-job preflight); the Serilog LocalAppData path; and the P3 formula/commands/IO clusters (IF text-boolean coercion, blank-criteria-as-zero, GETPIVOTDATA ordinal comparisons, named-range aggregate clamp, 1×1 merge drops, grid-bound shift clamps, fully-contained DV/CF move adjustment, duplicate-zip-entry rejection, r-less-row patch fallback, case-insensitive chart booleans, invariant attribute parsing).

Verification on integrated `main`: repository preflight passed, `FreeX.slnx` Release build 0 warnings/0 errors, default test lane 10,946 passed / 0 failed.

Still open from this review: the two large refactors (MainWindow god-object extraction; declarative schema-table sanitizer), whole-column `ApplyStyleCommand` used-range clamping, the `_isOpeningFile` guard timing, CF/DV/chart-range adjustment for partial-range cell shifts, the remaining P3 stability items (clipboard image catch-all, synchronous picture loads, screenshot-tour task handling), the remaining consolidations (A1 parsers, `SetAttributeIfDifferent`, `G17` formatting, cfvo mapping, `GridRange.TryIntersect`, A1 span formatting, test save helpers), the viewport double-build and render-cache clears, per-cell ClosedXML style application, hygiene-test altitude, UI-lane test split, and central package management.

## 2. Correctness And Data-Integrity Bugs

### P1 - Save pipeline races live edits and falsely marks them persisted (verified)

Evidence: [`SaveWorkbookToTargetAsync`](../../src/FreeX.App.Host/MainWindow.Backstage.cs#L742) awaits [`SaveWorkbookWriter.SaveAsync`](../../src/FreeX.App.Host/SaveWorkbookWriter.cs#L12), which runs [`adapter.Save(workbook, file)`](../../src/FreeX.App.Host/SaveWorkbookWriter.cs#L41) on the live model via [`Task.Run`](../../src/FreeX.App.Host/SaveWorkbookWriter.cs#L84). Save progress is a status panel only — no input lock, unlike the open path's blocking `OpenProgressOverlay`. On completion the code unconditionally runs [`MarkWorkbookSaved()`](../../src/FreeX.App.Host/MainWindow.Backstage.cs#L767).

Three manifestations:

- **Torn snapshot / aborted save**: typing or pasting during a long save mutates collections the serializer is enumerating — either an exception aborts the save or an inconsistent mix of pre/post-edit state is written (the temp-file + `File.Replace` pattern protects against partial files, not torn content).
- **False clean flag**: `MarkWorkbookSaved()` clears `_workbookDirty` even when edits arrived mid-save, so closing afterwards prompts nothing and the edits are silently lost.
- **Save-on-close variant (verified)**: [`MainWindow_Closing`](../../src/FreeX.App.Host/MainWindow.WorkbookLifecycle.cs#L56) awaits the save prompt/save, then sets `_suppressClosePrompt = true` and force-closes with no second dirty check — edits typed during the awaited save are discarded.
- **Stale-context continuation (plausible)**: the post-await block sets `_currentFilePath`/`_workbook.Name` with no check that the file context changed during the await; `OpenFileAsync` sets `_isOpeningFile` only after its own awaits, so opening workbook B during A's save lets A's continuation retarget the new context.

Recommended fix: treat all three together — either block input during save the way open does, or serialize from a cloned snapshot and only clear the dirty flag when no edits occurred mid-save (generation counter); re-check dirty state after the awaited save in the close flow before suppressing the prompt.

### P1 - Remove Duplicates deletes entire sheet rows outside the selected range (verified)

Evidence: [`RemoveDuplicateRowsCommand.Apply`](../../src/FreeX.Core.Commands/RemoveDuplicateRowsCommand.cs#L50) issues `new DeleteRowsCommand(_sheetId, row)` per duplicate, deleting the **whole sheet row**. The host passes the user's selection ([`MainWindow.DataCommands.cs`](../../src/FreeX.App.Host/MainWindow.DataCommands.cs#L221)).

Impact: select A1:B10 with unrelated data in D1:D10, run Data > Remove Duplicates — the D-column values on duplicate rows are destroyed and everything below shifts up across all columns, moving merges/CF/named ranges/charts sheet-wide. Excel removes only cells inside the range.

Recommended fix: delete and shift cells within the range only (the `DeleteCellsCommand` shift-up machinery is the right substrate once finding 3 is fixed), or at minimum constrain row deletion to selections spanning the used width. Add a regression test with data beside the selection.

Related (P3, same file): the duplicate key joins per-column `ToString()` with `\t` ([line 44-46](../../src/FreeX.Core.Commands/RemoveDuplicateRowsCommand.cs#L44)), so values containing tabs can collide across column boundaries and type-differing values can collide textually — a non-duplicate row gets deleted. Use a structural key (length-prefixed or tuple-based) and compare typed values.

### P1 - Insert/Delete Cells shifts raw cells with no formula rewrite or metadata adjustment (verified)

Evidence: [`InsertCellsCommand.Apply`](../../src/FreeX.Core.Commands/InsertDeleteCellsCommand.cs#L34) and [`DeleteCellsCommand.Apply`](../../src/FreeX.Core.Commands/InsertDeleteCellsCommand.cs#L206) capture and re-place raw cells only. The file contains no `RewriteAllFormulas` call and no handling for merges, comments, hyperlinks, conditional formats, or data validations — in contrast to `InsertRowsCommand`, which shifts 15 metadata collections and rewrites formulas.

Impact: B5 holds `=A5`; Insert Cells > Shift Down at A1 moves A5's data to A6 while B5 still reads `=A5` (now blank) — silently wrong results. Delete Cells leaves dangling references instead of `#REF!`; comments/hyperlinks stay at old addresses; merges overlapping the shifted band are neither blocked nor moved.

Recommended fix: route partial-range shifts through the same rewrite/metadata helpers the row/column commands use (a range-scoped `ShiftOp`), or block the operation when it intersects merges as Excel does. Test: formula above/below the shift band, merge overlap rejection, comment/hyperlink relocation.

### P1 - Comparison operators treat blank cells by type order, not Excel coercion (verified)

Evidence: [`CompareValues`](../../src/FreeX.Core.Formula/FormulaEvaluator.Operators.cs#L437) falls through to [`TypeOrder`](../../src/FreeX.Core.Formula/FormulaEvaluator.Operators.cs#L457) for mixed types with `BlankValue => 0`, below numbers. No blank coercion happens in the operator path (the function-side `ScalarEquals`/`CompareScalar` do coerce, making operators the outlier).

Impact: with A1 empty, `=A1=0`, `=A1=""`, and `=A1>-1` all return FALSE where Excel returns TRUE (blank coerces to 0 against numbers, "" against text, FALSE against booleans). `=IF(A1=0,...)` over not-yet-filled rows is one of the most common spreadsheet patterns; whole models mis-branch silently.

Recommended fix: in `CompareValues`, coerce `BlankValue` to the other operand's type class (0 / "" / FALSE) before the mixed-type fallback. Tests: blank vs number/text/bool for all six comparison operators, plus blank-vs-blank.

### P1 - No autosave, no crash recovery, crash handlers record-and-die (verified)

Evidence: [`RegisterCrashHandlers`](../../src/FreeX.App.Host/App.xaml.cs#L139) wires all three handlers solely to `diagnostics.RecordCrash`; no `Handled = true` triage, no emergency save. A source-wide search for autosave/recovery machinery finds none (the only hits are XLSX `fileRecoveryPr` metadata passthrough).

Impact: any unhandled exception in any of the ~1,349 App.Host handler files ends the process and an hour of unsaved edits with it. For a spreadsheet app already in tester distribution this is the single largest user-trust risk.

Recommended fix: timer-based autosave snapshot to LocalAppData using the existing `NativeJsonAdapter` (.fxl), a best-effort emergency snapshot inside the dispatcher handler, and a startup recovery prompt. All three pieces compose from existing infrastructure.

### P2 - One bad defined name silently drops all named ranges on save; per-sheet DV/merge failures also swallowed (verified)

Evidence: [`XlsxFileAdapter.Save.cs:320`](../../src/FreeX.Core.IO/XlsxFileAdapter.Save.cs#L320) wraps the entire `XlsxNamedRangeMapper.Save` in a catch that logs to `Debug.WriteLine` only. Same pattern per sheet for data validation ([line 302](../../src/FreeX.Core.IO/XlsxFileAdapter.Save.cs#L302)) and merged regions ([line 315](../../src/FreeX.Core.IO/XlsxFileAdapter.Save.cs#L315)).

Impact: one name ClosedXML rejects → the file is written with **zero** defined names and no user-visible warning; on reload every name reference evaluates `#NAME?`. The load path collects warnings for exactly these feature classes; the save path surfaces nothing.

Recommended fix: catch per item (per name/per rule/per region), keep saving the rest, and surface a save-warnings list to the host the way load warnings already flow. Test: workbook with one invalid + many valid names round-trips the valid ones and reports the bad one.

### P2 - Patch-save writes XML-invalid control characters and unescaped `_xHHHH_` text (verified: no sanitization exists in Core.IO)

Evidence: [`CreateInlineTextElement`](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackageSnapshot.cs#L6645) and the cached-value rewrite ([line 6436](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackageSnapshot.cs#L6436)) write cell text verbatim into XLinq nodes. Grep confirms no `XmlConvert.IsXmlChar` / `_x005F_` handling anywhere in `FreeX.Core.IO`.

Impact: (a) a cell containing a control char (ClosedXML decodes `_x000B_` to `\v` on load; paste can introduce others) makes `document.Save` throw `ArgumentException` and the whole save fails with no fallback to the full-save path; (b) literal text `_x000D_` round-trips into a real carriage return on next load; (c) raw `\r\n` inside `<t>` is normalized to `\n` by XML parsing — silent text alteration. The ClosedXML full-save path escapes correctly; only the patch path diverges.

Recommended fix: a single escape/sanitize helper applied at every patch-path text write (`_x005F_` escaping for literal escape-shaped text, `_xHHHH_` encoding for XML-invalid chars, CR preservation), plus a fallback: if the patch path throws, retry via full save. Fixtures: control-char cell, literal `_x000D_` text, CRLF text.

### P2 - Deleting a sheet leaves formulas referencing it untouched (verified)

Evidence: [`RemoveSheetCommand.Apply`](../../src/FreeX.Core.Commands/SheetCommands.cs#L113) calls `ctx.Workbook.RemoveSheet(_sheetId)` with no formula rewrite; [`RenameSheetCommand`](../../src/FreeX.Core.Commands/SheetCommands.cs#L66) in the same file proves the rewrite infrastructure exists.

Impact: `=Sheet2!B1` survives Sheet2's deletion textually (Excel rewrites to `#REF!`); if the user later creates a new, unrelated sheet named Sheet2 the formula silently binds to it — wrong results with no signal.

Recommended fix: add a `DeleteSheetOp` to the rewrite helpers converting references to the deleted sheet into `#REF!`, snapshotting originals for undo symmetric with rename.

### P2 - Approximate VLOOKUP/HLOOKUP/MATCH abort at the first type-mismatched entry (verified)

Evidence: [`BuiltInFunctions.Lookup.Legacy.cs:40`](../../src/FreeX.Core.Formula/BuiltInFunctions.Lookup.Legacy.cs#L40) — the linear scan `break`s at the first `CompareScalar > 0`. A text header above numeric data compares greater than any numeric lookup, so the scan ends at row 1 with no match.

Impact: `VLOOKUP(3, A1:B4, 2, TRUE)` with `A1="ID"` returns `#N/A` where Excel (binary search skipping type mismatches) finds the row. Tables-with-headers is the default real-world shape. Same pattern in `HlookupScalar` and `MatchScalar`.

Recommended fix: skip entries whose type differs from the lookup value's type in approximate mode instead of breaking. Tests: header-row tables for all three functions.

### P2 - ROUNDDOWN/ROUNDUP/TRUNC lack the decimal correction ROUND already has (verified)

Evidence: [`RounddownScalar`](../../src/FreeX.Core.Formula/BuiltInFunctions.MathCore.Rounding.cs#L188), [`RoundupScalar`](../../src/FreeX.Core.Formula/BuiltInFunctions.MathCore.Rounding.cs#L214), [`TruncScalar`](../../src/FreeX.Core.Formula/BuiltInFunctions.MathCore.Rounding.cs#L241) use raw `n * factor`; `RoundScalar` deliberately routes through `RoundWithExcelDigits`/`TryToExcelDecimal` to avoid exactly this.

Impact: `=ROUNDDOWN(4.35,2)` → 4.34 (4.35×100 = 434.99999999999994); Excel returns 4.35. Financial truncation is a high-visibility parity break.

Recommended fix: route all three through the same 15-significant-digit correction used by `RoundScalar`. Tests: the classic 4.35/2.675 family in both signs.

### P2 - `CompareScalar` calls any two mixed non-numeric values equal (finder-verified)

Evidence: [`BuiltInFunctions.Coercion.cs:181`](../../src/FreeX.Core.Formula/BuiltInFunctions.Coercion.cs#L181) returns `(aIsNumber?0:1)-(bIsNumber?0:1)` → 0 for blank-vs-text, text-vs-bool, etc.

Impact: approximate `VLOOKUP("Zed", …, TRUE)` over a range with a blank treats the blank as the best match; `SORT` interleaves booleans/blanks into text; `MATCH` returns positions instead of `#N/A`.

Recommended fix: give `CompareScalar` the full Excel type ordering (number < text < bool, blanks coerced per finding 4's rules) consistent with the operator-path fix.

### P2 - Duplicate-values conditional formatting highlights empty cells as duplicates (finder-verified)

Evidence: [`ViewportConditionalFormatEvaluator.Aggregates.cs:29`](../../src/FreeX.Core.Calc/ViewportConditionalFormatEvaluator.Aggregates.cs#L29) counts `NormalizeDisplayValue(BlankValue)` = `""` in `valueCounts`; the dense path enumerates all cells in range while the sparse path (>10k cells) enumerates occupied only — so behavior also flips at the threshold.

Impact: a duplicate-values rule over a column with two filled and many empty cells paints every empty cell as a duplicate; Excel ignores blanks. Dense/sparse divergence means scrolling-size-dependent behavior.

Recommended fix: skip blanks in value counting on both paths; add a dense-vs-sparse equivalence test.

### P2 - Text-to-number coercion accepts month names and malformed grouped numbers (finder-verified)

Evidence: [`ExcelTextNumberParser.cs:46`](../../src/FreeX.Core.Formula/ExcelTextNumberParser.cs#L46) falls back to unrestricted `DateTime.TryParse`; the numeric branch uses `NumberStyles.Any`.

Impact: `="March"+0` yields a current-year date serial (year-dependent results!) instead of `#VALUE!`; `="1,2"+0` yields 12. This is the central coercion used by all arithmetic on text.

Recommended fix: restrict the DateTime fallback to Excel-recognized date/time text shapes (digit-containing patterns), and validate thousands-grouping placement before accepting grouped numbers.

### P2 - Sort loses hyperlink anchoring and formatted-blank styling, partly unrecoverable by undo (finder-verified)

Evidence: [`SortCommand` payload capture](../../src/FreeX.Core.Commands/SortCommand.cs#L303) covers Cell/Comment/ThreadedComment only; `Sheet.SetCell` clears style-only entries that `Revert` never restores. `FillCellsCommand` and `MoveRangeCommand` both move hyperlinks — Sort is the outlier.

Impact: sorted hyperlinks sit on unrelated rows; fill color on blank cells inside the sort range is permanently lost even after Ctrl+Z.

Recommended fix: extend the payload with hyperlink + style-only capture, mirroring `MoveRangeCommand`.

### P2 - Undo of row/column insert leaves the data-validation lookup cache stale (finder-verified)

Evidence: the in-place [`RestoreRuleRanges`](../../src/FreeX.Core.Commands/RowColumnShiftHelpers.Rules.cs#L21) overload mutates `rule.AppliesTo` without `NotifyRulesChanged`, while the forward shift does notify; `DataValidationLookupCache.RefreshIfNeeded` keys on version+count.

Impact: insert row above a validated cell, then undo — the dropdown and validation silently stop applying at the restored address until an unrelated DV change bumps the version.

Recommended fix: call `NotifyRulesChanged` from the restore path; test validates a cell post-undo.

### P2 - Autofill undo permanently destroys formatted-blank styling (finder-verified)

Evidence: [`AutofillCommand.cs:52`](../../src/FreeX.Core.Commands/AutofillCommand.cs#L52) snapshots `GetCell(...)?.Clone()` only; `Revert` with null old cell just clears. Every sibling write command snapshots `GetStyleOnly`.

Impact: drag-fill over cells that carried fill color via style-only entries, undo — color gone for good.

Recommended fix: capture/restore style-only entries like `FillCellsCommand` does.

### P3 - Remaining verified-pattern correctness items

- **Merge shrink leaves 1×1 merges** ([`DeleteRowsCommand.cs:108`](../../src/FreeX.Core.Commands/DeleteRowsCommand.cs#L108), also `RowColumnShiftHelpers.Merges.cs:76`): `A5:A6` minus row 6 keeps `A5:A5`, serialized as `<mergeCell ref="A5:A5"/>` which Excel repairs. Drop merges that shrink below 2 cells.
- **Range shifts overflow the grid** ([`RowColumnShiftHelpers.cs:13`](../../src/FreeX.Core.Commands/RowColumnShiftHelpers.cs#L13)): full-column CF/DV/named ranges get `End.Row + count` with no `MaxRow` clamp → `A1:A1048577` persisted and saved. Clamp to grid bounds.
- **Drag-move leaves DV/CF behind** ([`MoveRangeCommand.cs:86`](../../src/FreeX.Core.Commands/MoveRangeCommand.cs#L86)): cells/comments/hyperlinks move, validation and conditional formats stay on the vacated range; Excel moves both on cut.
- **`IF("TRUE",1,2)` returns `#VALUE!`** ([`FormulaEvaluator.ControlFlow.cs:33`](../../src/FreeX.Core.Formula/FormulaEvaluator.ControlFlow.cs#L33)): Excel coerces text TRUE/FALSE in IF conditions; the rejecting switch is copy-pasted at four sites.
- **Blank COUNTIF/SUMIF criteria match blanks, not zeros** ([`BuiltInFunctions.Criteria.cs:75`](../../src/FreeX.Core.Formula/BuiltInFunctions.Criteria.cs#L75)): Excel documents empty-cell criteria as "treated as 0".
- **GETPIVOTDATA matching is locale-sensitive** ([`BuiltInFunctions.Pivot.cs:25`](../../src/FreeX.Core.Formula/BuiltInFunctions.Pivot.cs#L25)): ~10 `CurrentCultureIgnoreCase` comparisons → Turkish-I mismatches. Switch to `OrdinalIgnoreCase`.
- **Named ranges miss the fast-aggregate full-range clamp** ([`FormulaEvaluator.FastAggregates.cs:570`](../../src/FreeX.Core.Formula/FormulaEvaluator.FastAggregates.cs#L570)): `=SUM(Data)` for `Data = $A:$B` errors `#REF!` while `=SUM(A:B)` works — the named-range echo of the already-fixed INDIRECT gap.
- **Patch-save can't find r-less rows** ([`SourcePackageSnapshot.cs:6513`](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackageSnapshot.cs#L6513)): rows omitting the optional `r` attribute are skipped, so edits create duplicate row elements and shift implied positions.
- **`ReplaceXml` keeps stale duplicate zip entries** ([`XlsxPackageXmlEditor.cs:11`](../../src/FreeX.Core.IO/XlsxPackageXmlEditor.cs#L11)): only the first same-named entry is deleted; crafted packages defeat the sanitizers. Reject duplicate entry names at load.

## 3. Stability And Threading

### P2 - PDF/XPS export runs fully synchronous on the UI thread (finder-verified)

Evidence: [`MainWindow.PrintExport.cs:92`](../../src/FreeX.App.Host/MainWindow.PrintExport.cs#L92) — document render + file write inline in the click chain; no progress, no cancel. Same shape as the Get Data freeze fixed in `286c050e1`.

Impact: multi-second-to-minute "Not Responding" on large workbooks. Fix with the established async + progress treatment (paginator rendering must stay on an STA thread).

Related (P3): [`ExportAsXps`](../../src/FreeX.App.Host/MainWindow.PrintExport.cs#L177) opens the target `Package` outside `using`; an exception before `XpsDocument` takes ownership leaves the destination 0-byte and locked until exit. Also writes `FileMode.Create` directly to the destination instead of temp+replace.

### P3 - Other stability items

- **Bare `catch { return false; }` around clipboard image paste** ([`MainWindow.ClipboardCommands.cs:339`](../../src/FreeX.App.Host/MainWindow.ClipboardCommands.cs#L339)): swallows command-bus failures, then falls through to text-paste paths — user sees garbage or nothing with no signal. Narrow the try to decode, log the rest.
- **Synchronous `File.ReadAllBytes` in picture flows** ([`MainWindow.Drawing.cs:31`](../../src/FreeX.App.Host/MainWindow.Drawing.cs#L31), `PageLayout.cs:135`, `HeaderFooterDialog.Pictures.cs:25`): a slow network path freezes the app until SMB timeout.
- **Fire-and-forget screenshot-tour tasks without try/catch** ([`MainWindow.ScreenshotTour.cs:438`](../../src/FreeX.App.Host/MainWindow.ScreenshotTour.cs#L438)): env-gated (CI), but failures either crash via async-void or hang CI silently.

## 4. Performance

### P2 - Conditional-format aggregates rebuilt from scratch on every viewport rebuild (finder-verified)

Evidence: [`ViewportService.GetViewport`](../../src/FreeX.Core.Calc/ViewportService.cs#L29) unconditionally calls `BuildConditionalFormatContext`; `PrecomputeAggregates` re-enumerates every occupied cell per rule (sort + per-cell string normalization) and `PrecomputeFormulaCaches` re-lexes/parses every formula rule — per scroll tick and keystroke, to repaint ~600 visible cells.

Recommended fix: cache `CfEvaluationContext` per sheet keyed on a content/CF revision counter; invalidate on edit, not on scroll. Highest-leverage perf fix in the review.

### P2 - Recalc ordering is O(dirty² × ranges) (finder-verified)

Evidence: [`DependencyGraph.CountPrecedentsWithin`](../../src/FreeX.Core.Calc/DependencyGraph.cs#L805) scans the entire dirty-candidate set per dirty cell with range precedents; 20k cells of `=SUM($A$1:$A$10)` dirty from one edit → ~400M `Contains` checks, run twice when volatiles exist.

Recommended fix: bucket the candidate set per sheet (the `RangeDependencyIndex` pattern already exists for the dependent direction) and query within range bounds.

### P2 - Whole-column formatting touches 1,048,576 cells (finder-verified)

Evidence: [`ApplyStyleCommand.Apply`](../../src/FreeX.Core.Commands/ApplyStyleCommand.cs#L41) loops `_range.AllCells()` with no used-range clamp; whole-column selection produces ~1M snapshot tuples and 1M style-only entries — which also flips `HasStyleOnlyCells` and permanently degrades the viewport fast path. Same shape in [`SelectionStyleCommandPlanner.cs:81`](../../src/FreeX.App.Host/SelectionStyleCommandPlanner.cs#L81) for borders.

Recommended fix: clamp to used range plus a column/row default-style entry for the unbounded remainder (Excel's columnar style model).

### P3 - Other performance items

- **Viewport built twice on header-width misestimates** ([`MainWindow.Viewport.cs:369`](../../src/FreeX.App.Host/MainWindow.Viewport.cs#L369)): row-digit boundary scrolls discard and rebuild the full viewport including the CF scan. Compute header width from row metrics before materializing.
- **Render caches cleared every frame** ([`GridView.Rendering.cs:424`](../../src/FreeX.App.UI/GridView.Rendering.cs#L424)): brushes/pens/typefaces are immutable-keyed but re-allocated per render pass (FontFamily resolution included). Persist across frames with a size cap.
- **Full save applies ~15 ClosedXML style setters per styled cell** ([`XlsxFileAdapter.Save.cs:87`](../../src/FreeX.Core.IO/XlsxFileAdapter.Save.cs#L87)): cache one applied style per distinct `StyleId` instead.
- **Autofill recalc materializes the whole fill rectangle** ([`MainWindow.CellsCommands.cs:677`](../../src/FreeX.App.Host/MainWindow.CellsCommands.cs#L677)): use the command's `AffectedCells` like neighboring paste/fill paths.
- **Dependent-link removal is `List.Remove`** ([`DependencyGraph.cs:166`](../../src/FreeX.Core.Calc/DependencyGraph.cs#L166)): popular precedent cells make formula rewrites linear per edit, quadratic in bulk. Use a set or swap-remove.

## 5. Consistency And Duplication (Refactoring)

- **P2 - Six `QuoteSheetName` implementations, three divergent predicates** — for sheet `Q1-Q2`, [`XlsxSparklineMapper.cs:155`](../../src/FreeX.Core.IO/XlsxSparklineMapper.cs#L155) and `XlsxChartXmlWriter.Metadata.cs:378` emit **unquoted** `Q1-Q2!A1:B2` into saved XML (parsed as subtraction = broken reference), while `ConsolidationRules.cs:76`, `SpreadsheetXmlFileAdapter.Names.cs:165`, `PasteLinkService.cs:31`, `PivotUiPlanner.cs:178` quote correctly. Consolidate on one shared helper with the strictest predicate.
- **P2 - A1/column parsing re-implemented ≥6 times** — two near-identical private parsers inside [`XlsxFileAdapter.SourcePackageSnapshot.cs`](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackageSnapshot.cs#L3348) alone, both using `checked(...)` that throws an unhandled `OverflowException` on a 7-letter column in crafted input, where canonical `CellAddress.TryParse` returns false gracefully; further copies in `DataValidationService.ListSources.cs:280`, `FormulaAuditingService.Errors.cs:1158`, `XlsxExcelCompatibilityNormalizer.cs:445`. Delegate to `CellAddress` like `SpreadsheetXmlFileAdapter.Names.cs:151` already does.
- **P2 - Chart-axis boolean parsing is case-sensitive** ([`XlsxChartAxisReader.cs:489`](../../src/FreeX.Core.IO/XlsxChartAxisReader.cs#L489)) while the canonical `XlsxXmlAttributeReader.ReadBoolAttribute` is case-insensitive — `True` from lenient producers loads differently on the chart path. A third variant exists in `XlsxWorksheetDiagnosticsMapper.cs:83`.
- **P3** - Culture-sensitive `int/uint.TryParse` at 6 reader sites vs the invariant canonical helper (`XlsxChartAxisReader.cs:487`, `SheetXmlLayout.cs:692`, theme/layout readers); CI already runs under bg-BG where this class of bug bites.
- **P3** - `SetAttributeIfDifferent` declared in 5 writer files with drifting signatures; `G17` invariant double formatting inlined at 8 sites; cfvo type mapping tripled across write/read; `GridRange` intersection re-derived 4 times (add `GridRange.TryIntersect`); A1 span-formatting tripled (`SpreadsheetDisplayFormatter`, `NativeJsonAdapter.CellDto`, `XlsxStyleOnlyCellWriter`); per-test-class save-to-bytes helpers ×5 (move to SharedTestInfrastructure).

## 6. Architecture And Altitude

- **P2 - XLSX sanitizer treadmill** — 40 per-element normalizer/sanitizer classes plus a 1,921-line orchestrator with ~60 paired `Has*/Normalize*` methods, each re-parsing the same package parts; recent git history shows one new normalizer per day. Replace with a declarative per-complex-type schema table (allowed attributes + child sequence, derivable from the DocumentFormat.OpenXml metadata already used in tests) driving a single normalization pass — a new element becomes one table row. ([`XlsxClosedXmlLoadPackageSanitizer.cs`](../../src/FreeX.Core.IO/XlsxClosedXmlLoadPackageSanitizer.cs#L1372))
- **P2 - MainWindow god object** — 53 partial files, 26,521 lines, owning command routing, lifecycle, dirty tracking, and feature state; pure-logic Planner classes are already extracted, but document state (`_workbookDirty`, `_currentFilePath`) is window-private. Extract a DI-registered `WorkbookSession`/document service owning dirty state and save/open lifecycle — this is also the natural home for the save-race fixes (finding 1) and autosave (finding 5).
- **P3 - String-based source-hygiene tests** — 40 test files assert literal substrings of source files (e.g. `MainWindowSourceHygieneTests.cs:18`); renames break non-behavioral tests while behavior can regress green. Prefer reflection/Roslyn-based placement checks plus behavioral tests; keep text scans for true text artifacts.
- Layering verified clean: no Core→App references, no WPF usings in Core projects, `docs/architecture/architecture.md` matches the project graph.

## 7. Gaps (Testing, CI, Recovery)

- **P2 - PR CI never builds `FreeX.slnx`** ([.github/workflows/ci.yml:42](../../.github/workflows/ci.yml#L42)): tools projects (FidelityCompare, ExcelOpenSmoke, ChartInteropCompare, AppIoBench) first compile at release time — a Core.IO API rename can merge green and break release day. Point the CI build step at `FreeX.slnx` (tests stay on `FreeX.DefaultTests.slnx --no-build`).
- **P3 - All App.Host/App.UI tests ride the non-gating UI lane** — including pure planner tests needing no WPF session. Split UI-session-dependent tests from pure logic and move the latter into the default gating solution.
- **P3 - `ci.yml` has no concurrency group and the UI job skips preflight** — rapid PR pushes stack redundant 60-minute Windows runs; add `concurrency: ci-${{ github.ref }}` with cancel-in-progress and share the preflight step.
- **P3 - Serilog writes to relative `logs/`** ([App.xaml.cs:35](../../src/FreeX.App.Host/App.xaml.cs#L35)) while crash diagnostics correctly target LocalAppData — launched via file association, logs scatter or silently fail exactly when a tester reports a startup bug.
- **P3 - No central package management** — ClosedXML/xunit/FluentAssertions versions pinned per-csproj across ~13 projects; adopt `Directory.Packages.props`.
- Autosave/crash recovery is the headline gap — covered as P1 in section 2.

## 8. Clean Signals Worth Recording

- Repository preflight passed (JSON/XML/tools/workflows/SDK/project-reference/solution/docs/conflict-marker checks, 2,793 files scanned).
- On `main` (`8abbf3406`) in a clean worktree: full `FreeX.slnx` Release build succeeded with 0 warnings/0 errors, and the default test lane passed clean — 10,684 passed, 0 failed, 116 skipped across Core.Calc (750), App.Services (953), Integration (71), Core.Model (3,717), Core.Formula (2,786), and Core.IO (2,407) test projects.
- Note for the record: the review-snapshot commit `0a7777100` failed 17 default-lane tests in the same clean-worktree setup (13 Core.IO patch-save/retention, 4 Core.Model accessibility-CF) — all fixed by later `main` commits. Merged-but-red intermediate states like this are what the CI gap in section 7 (PR CI building only `FreeX.DefaultTests.slnx`) makes more likely to go unnoticed.
- The four most recent merges (`9cf750817` oleSize, `e8add9d6b` definedNames, `5f39d13e9` retention loader cleanup, `0a7777100` CF aggregate parity) audited line-by-line including removed-behavior checks: clean; kept elements are repositioned via the existing `WorkbookChildOrder`, removal predicates fire only on schema-invalid content, and the new CF parity code is defensively written.
- All 2026-06-03 review fixes verified present (secure XML loads, stream caps, lexer bounds, INDIRECT clamp, tester-release concurrency at `tester-release.yml:48`, MSIX signing path, tool projects in `FreeX.slnx`).
- Insert/Delete Rows/Columns undo paths are impressively symmetric (15+ collections snapshotted, formula rewrite snapshots restored in the correct order); composite commands roll back correctly on mid-failure; no shared-mutable-state undo corruption found across ~27 audited command pairs.
- Core layering is clean; `DependencyGraph` cycle detection and Kahn ordering check out; previously-optimized hot paths (render dispatch, AST caching, number-format caches, COUNTIF regex cache) hold up.
- No commented-out code blocks; no product `NotImplementedException`; dependency graph shows no pre-release packages.

## 9. Verification Commands

```powershell
git status --short --branch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1   # passed (primary tree)
git worktree add .worktrees/review-verify-20260611 main                                       # isolated verification
dotnet build FreeX.slnx --configuration Release                                              # passed on main, 0W/0E
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"  # 10,684 passed / 0 failed
```

The primary tree's in-progress test edit (session-owned, references a not-yet-existing `ContentTypeOverridePartNames`) breaks `FreeX.Core.IO.Tests` compilation there, which is why verification used the isolated worktree. This review changed documentation only.
