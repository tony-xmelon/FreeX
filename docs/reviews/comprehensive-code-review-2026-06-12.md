# FreeX Comprehensive Code Review - 2026-06-12

## 0. Method And Coverage

Full-workspace review at `main` HEAD `1fe1b2644` ("Merge recovery preserved gaps"), one day after the 2026-06-11 review and the two-pass fix campaign that resolved all of its findings. Eight independent finder passes, deliberately weighted toward (a) line-by-line audit of the ~30 fix branches merged on 2026-06-12 (new code is the highest-risk code) and (b) areas the prior review did not reach: array/date/financial/text formula functions, chart/pivot/CSV/native-format IO, multi-window and Find/Replace host behavior, the XLSX load path, command-layer protection guards, and the `FreeX.App.Avalonia` macOS port (never previously reviewed). Every P1 and the highest-impact P2 candidates were re-verified inline against current `main` source; several finder claims about Excel semantics were checked and refuted (listed in section 4.3 rather than reported as findings).

Carry-forward items from the 2026-06-11 review were individually re-verified on current `main` and are reported in section 8 with current sizing.

## 1. Executive Summary

The default lane is green, the prior review's findings remain fixed, and the prior CI/localization gaps were closed by other sessions (`7e65e5942`, `5e2f6a840`). This review's headline themes:

1. **Two P1 regressions shipped in yesterday's fix campaign.** The close-flow "belt-and-suspenders" dirty re-check makes **"Don't Save" unable to close the window** (the discard path never clears the dirty flag), and the per-window `WorkbookDocumentState` extraction cemented a **multi-window data-loss hole**: sibling windows of a shared workbook are never marked dirty, so the last-closed window skips the save prompt and discards edits.
2. **The command layer has systematic protection-guard omissions.** Goal Seek and Data Table write to protected sheets with no check at all; sparklines, named ranges (under structure protection), and table create/resize also bypass guards — and overlapping tables produce Excel-invalid files.
3. **The new macOS Avalonia port is an unmanaged fork.** 14,500 lines in one file, its own parallel dirty/save state (none of yesterday's save-race fixes apply to it), no CI compilation on the macOS lane, no behavioral tests, no architecture-doc presence, no localization.
4. **IO round-trip fidelity gaps cluster in charts and pivots** (numeric categories rewritten as text refs, `refreshOnLoad` defaulting against spec, shared-item type re-inference, chartEx axes dropped), and the `.fxl` native format — now load-bearing as the **crash-recovery snapshot format** — silently drops `IsVeryHidden` and needs a fidelity inventory.
5. **The recovery/crash-handler flow (new yesterday) has correctness holes**: background-thread crashes silently skip the emergency save, only the first recovery candidate is ever offered, and a queued startup file-open can prompt the user into discarding a just-recovered workbook.

### Resolution update - 2026-06-12 follow-up

All findings below were fixed and merged to `main` the same day through twelve `fix2/*-20260612` branches in three integration waves:

- **P1s**: close-flow Don't-Save loop fixed via `WindowCloseDecisionPlanner` (dirty re-check applies only after a save ran); `WorkbookDocumentState` made document-scoped (Singleton) with title fan-out, sibling notify on open/new/save, registry unregister moved into Closing, New-Window sheet adoption, and undo/redo save-point tracking via command-stack depth; Goal Seek/Data Table/sparkline/named-range/Subtotal protection guards added plus a reflection census test over all 197 command implementors (43 guard tests).
- **Recovery/crash flow**: emergency save marshaled to the dispatcher with timeout; all recovery candidates offered (extras open in new windows; declined ones deleted, never silently lost); recovery opens suppress recent-files; startup file-args open in a new window when recovery was accepted; snapshot ids include a launch GUID against PID reuse.
- **Tables/fxl**: create/resize overlap guards; `.fxl` serializes `IsVeryHidden`; a 21-test fidelity inventory now pins the native-format gap list (structured tables, code names, sheet defaults, drawings/charts/pivots as documented exclusions).
- **Chart/pivot fidelity**: numeric categories emit `numRef`; `refreshOnLoad` defaults false per spec; shared-item element kinds preserved; chartEx axis emission per type with Y-axis scaling; unique pivot-records rel ids; comment authors round-trip; threaded-comment paths use next-free index; unparseable series formulas and rich axis titles preserved verbatim; dxf numFmtIds allocated above existing custom-format ids.
- **Find/Replace**: dialog reuses a single instance and closes on workbook swap; Formulas-mode replace clears the stale cached value; plain-text searches skip number cells with proven-equivalent results.
- **Campaign P2/P3s**: `StyleOnlyCreateZone` clamps only the unbounded dimension (empty-column formatting works); `AdditionalRanges` adjusted independently of the primary range on delete/insert; Insert-cells Revert ordering proven required and pinned with an undo-redo-undo convergence test; CF cache eviction skips stale queue slots; Remove Duplicates detects before snapshotting.
- **Performance**: workbook.xml parsed once per load; rels traversal de-quadratified with an equivalence test; worksheet save normalization restructured to a single-pass driver (~36 → ~10 passes, one parse per worksheet); formula-bar overlay Borders pooled; quoted-sheet parsing allocation-free; status-bar automation cached; style-index dictionary reused across sheets (row-major ordering verified).
- **Sanitizer migration**: container-element schema support added (`XlsxWorkbookContainerElementSchema` — required-attr pruning, multi-key dedup, post-process hooks); 6 more normalizers became table rows (definedNames, externalReferences, functionGroups, webPublishObjects, pivotCaches, oleSize); residual: bookViews/customWorkbookViews/extLst (recursive extLst normalization, documented).
- **Avalonia hardening**: macOS CI lane builds the Avalonia project; `WorkbookSession` gained dirty-generation + mid-save-edit detection; re-entrancy guards set before awaits; `AvaloniaCloseDecisionPlanner`/`AvaloniaSaveCompletionPlanner` extracted with a new 38-test `FreeX.App.Avalonia.Tests` project in the default lane; architecture.md now documents App.Services and App.Avalonia. (Full localization and file splitting remain documented follow-ups.)
- **Formula hardening**: XIRR sign validation; IRR/XIRR bisection fallback; fraction-format alignment padding; FILTER OOB claim disproven with pinning tests; FIXED blank-cell-decimals behavior verified CORRECT (review claim withdrawn — blank refs coerce to 0); four wall-clock perf tests converted to `[BenchmarkFact]` (removes the gating-lane flake); ClosedXML reflection probe test added; 15 oracle cases (YEARFRAC/DATEDIF/TEXT/VDB) added to FreeX.FidelityCompare for Excel arbitration.
- **Consistency/l10n**: wildcard→regex unified in cached `FormulaWildcardHelper` (three copies deleted); `SheetNameFormatter` stragglers fixed (chart-XML `TRUE`/`A1` corruption regression-tested); hex-color parsers and column-name copies consolidated; `Workbook.ValidateSheetNameStructure` extracted and shared with the dialog; quoting wrappers deleted; 22 raw-English `_messageService` sites moved to UiText (31 new keys × 44 resx) and the localization guard test extended to police `_messageService` calls.

Verification on integrated `main`: repository preflight passed, `FreeX.slnx` Release build 0 warnings/0 errors, default test lane green (results recorded in the review log). Remaining documented defers: full Avalonia localization/splitting, MainWindow next extraction seams, hygiene-test conversion convention, column-default styles, `Workbook.Clone` for background autosave serialization, and the FidelityCompare oracle run (needs a machine with Excel).

## 2. Regressions From The 2026-06-12 Fix Campaign (verified inline)

### P1 - "Don't Save" can never close the window

Evidence: [`MainWindow_Closing`](../../src/FreeX.App.Host/MainWindow.WorkbookLifecycle.cs#L60) — after the save prompt, `DiscardWithoutSaving` passes the Cancel check, then hits the belt-and-suspenders `if (_workbookDirty) return;` (line ~90). The discard path never clears the dirty flag ([`ConfirmSaveBeforeDestructiveActionAsync`](../../src/FreeX.App.Host/MainWindow.WorkbookLifecycle.cs#L34) returns without `MarkWorkbookSaved`), so the guard fires every time: the window re-opens the dialog on every close attempt and can only be closed by saving or killing the process.

Fix: apply the dirty re-check only when `confirmation == Continue` (a save actually ran); `DiscardWithoutSaving` should proceed to close unconditionally. Add a close-flow test for all three dialog outcomes.

### P1 - Multi-window: sibling windows never dirty → silent data loss

Evidence: [`RefreshFromSharedWorkbook`](../../src/FreeX.App.Host/MainWindow.MultiWindow.cs#L65) updates viewport/title only — no `MarkWorkbookDirty()`. Each window owns a Transient [`WorkbookDocumentState`](../../shared/Free.Shared.AppServices/WorkbookDocumentState.cs); the workbook is shared. Edit in window A → B's `IsDirty` stays false; close A (prompt, maybe discard), then close B → line-62 fast path (`!_workbookDirty`) → `PrepareActiveWorkbookForFinalClose()` with no prompt → all unsaved edits discarded.

Root cause is architectural: dirty state is a property of the *document*, not the window. Fix: share one `WorkbookDocumentState` per workbook (scoped like `WorkbookRef`), or broadcast `MarkDirty` in `NotifyWorkbookChanged`. Related P2s in the same cluster:

- [`OpenFileAsync`](../../src/FreeX.App.Host/MainWindow.Backstage.cs#L393) replaces `_workbookRef.Current` without `NotifyOtherWindowsOfWorkbookChange()` — siblings keep stale `_workbook` while the shared command bus resolves the new workbook: commands from a sibling mutate the wrong workbook against a stale viewport (verified: no Backstage caller of the notify method).
- After Save As in window A, siblings get no notification — B's title/file-path context stays stale; Save in B re-prompts for a path (finder-verified).
- [`WorkbookWindowRegistry`](../../src/FreeX.App.Host/WorkbookWindowRegistry.cs) unregisters on `Closed` while `IsFinalWorkbookWindowClose()` reads `Count` during `Closing` — two near-simultaneous closes can both see Count=2 and neither runs final-close cleanup (finder-verified).
- P3: New Window always opens on `Sheets[0]`, not the active sheet; [`ExecuteUndo`](../../src/FreeX.App.Host/MainWindow.CommandExecution.cs#L331) marks dirty unconditionally even when undoing back to the save point (verified).

### P2 - Whole-column formatting of an empty column does nothing

Evidence: [`StyleOnlyCreateZone`](../../src/FreeX.Core.Commands/ApplyStyleCommand.cs#L168) intersects an unbounded selection with the used range in BOTH dimensions; selecting empty column A on a sheet whose data lives in B:D yields `startCol(2) > endCol(1)` → null → Pass 2 skipped → Bold on column A styles nothing and undo records nothing (verified inline). Fix: clamp only the unbounded dimension — whole-column selections should keep their selected columns and clamp rows to the used-range rows (or the 1,000-row empty-sheet default already used in the no-content branch).

### P2 - Emergency crash-save silently no-ops for background-thread crashes

Evidence: [`RegisterCrashHandlers`](../../src/FreeX.App.Host/App.xaml.cs#L170) — `AppDomain.UnhandledException` fires on the faulting thread; [`TryEmergencySaveAllWindows`](../../src/FreeX.App.Host/App.xaml.cs#L195) iterates `Current.Windows` (UI-thread-affine; throws from other threads) inside a swallow-all catch → for the very crashes the AppDomain handler exists to cover, the snapshot silently never happens; when it does proceed it serializes the live workbook racing the UI thread (verified inline). Fix: marshal via `Current.Dispatcher.Invoke` with a short timeout, accepting best-effort failure explicitly.

### P2 - Startup recovery: first candidate only; recent-files pollution; file-arg collision

Evidence: [`OfferStartupRecovery`](../../src/FreeX.App.Host/App.xaml.cs#L229) — `candidates[0]` is the only one offered on Yes; remaining candidates are never deleted and are re-offered forever (verified inline; the No path correctly deletes all). The Yes path opens the snapshot via `OpenStartupFileAsync(candidate.SnapshotPath)`, which pollutes recent files with the soon-deleted `.fxl` path (finder-verified), and a command-line file argument queued by `OnStartup` runs after recovery, prompting "Save changes?" on the just-recovered (deliberately dirty-marked) workbook — "No" discards the recovery (finder-verified). Fixes: loop or offer-per-candidate; suppress recent-files for recovery opens; skip the queued file-arg (or open it in a new window) when recovery was accepted.

### P3 - Smaller campaign regressions (verified or finder-verified)

- **CF context cache eviction queue admits duplicate keys** ([`ViewportService.ConditionalFormats.cs`](../../src/FreeX.Core.Calc/ViewportService.ConditionalFormats.cs#L29)): a re-inserted key occupies two queue slots; the stale slot later evicts the live entry → redundant rebuilds with >8 sheets. Dedup on enqueue or use an LRU keyed set.
- **`AdjustRulesDeleteShiftUp` skips `AdditionalRanges` when `AppliesTo` was untouched** ([`RowColumnShiftHelpers.Rules.cs`](../../src/FreeX.Core.Commands/RowColumnShiftHelpers.Rules.cs#L287)): a partial-overlap primary range leaves fully-deleted additional ranges dangling.
- **`InsertCellsCommand.Revert` restores formulas before cell positions** ([`InsertDeleteCellsCommand.cs`](../../src/FreeX.Core.Commands/InsertDeleteCellsCommand.cs#L151)): formula text is written to still-shifted addresses; any dirty-marking triggered there targets addresses about to move. Reorder or document why it's benign.
- **dxf `numFmtId` uses post-increment index** ([`XlsxAdvancedConditionalFormatWriter.DifferentialStyles.cs`](../../src/FreeX.Core.IO/XlsxAdvancedConditionalFormatWriter.DifferentialStyles.cs#L53)): corrected analysis — `formatCode` is inline so nothing breaks today, but ids `165+N` can collide with the workbook's own custom formats (≥164) since existing ids aren't consulted. Allocate above the existing max id.
- **PID-reuse can clobber an unrecovered snapshot** ([`MainWindow.Autosave.cs`](../../src/FreeX.App.Host/MainWindow.Autosave.cs#L33)): snapshot id = `recovery-{ProcessId}-w{index}`; a recycled PID overwrites the crashed session's file on the first tick after the user declines recovery. Add a launch GUID to the id.
- **Remove Duplicates snapshots the full rectangle before detecting any duplicate** ([`RemoveDuplicateRowsCommand.cs`](../../src/FreeX.Core.Commands/RemoveDuplicateRowsCommand.cs#L70)): detect first, snapshot only when something will change.
- **ClosedXML reflection style-path** ([`XlsxFileAdapter.cs`](../../src/FreeX.Core.IO/XlsxFileAdapter.cs#L851)): degrade-to-null fallback is good; add a startup assertion test pinned to the ClosedXML version so a package bump that changes `SetStyle` semantics fails loudly in CI rather than silently.

## 3. Correctness And Data Integrity (new findings)

### P1 - Protection guards missing from Goal Seek and Data Table (verified inline)

[`GoalSeekCommand.Apply`](../../src/FreeX.Core.Commands/GoalSeekCommand.cs#L23) and both [`DataTableCommand`](../../src/FreeX.Core.Commands/DataTableCommand.cs#L35) variants call `sheet.SetCell` with zero protection checks (no `RejectIfProtected`, no `CanEditCell` — verified by grep). A protected sheet's locked cells are silently overwritten. Fix: add the standard guards; then sweep ALL `IWorkbookCommand` implementors with a test that asserts every cell-writing command rejects a protected sheet (the systematic gap deserves a systematic guard test, not four spot fixes).

Same family (finder-verified): [`AddSparklineCommand`](../../src/FreeX.Core.Commands/SparklineCommands.cs#L28) (no protection check), [`DefineNamedRangeCommand`/`RemoveNamedRangeCommand`](../../src/FreeX.Core.Commands/DefineNamedRangeCommand.cs#L31) (no workbook-structure-protection check; Excel blocks name edits under structure protection), [`SubtotalCommand`](../../src/FreeX.Core.Commands/SubtotalCommand.cs#L56) (sub-commands applied directly, partial-failure leaves generic error).

### P2 - Overlapping structured tables produce Excel-invalid files (finder-verified)

[`CreateStructuredTableCommand`](../../src/FreeX.Core.Commands/StructuredTableCommand.cs#L25) and [`ResizeStructuredTableCommand`](../../src/FreeX.Core.Commands/StructuredTableDesignCommands.cs#L75) never check `StructuredTables.Any(t => t.Range.Overlaps(...))` — Excel refuses overlapping tables ("Tables cannot overlap") and may treat the file as corrupt. Add the overlap guard to both plus a round-trip validation test.

### P2 - Chart/pivot round-trip fidelity (finder-verified, IO breadth pass)

- **Numeric chart categories always written as `<c:strRef>`** ([`XlsxChartXmlWriter.Series.cs`](../../src/FreeX.Core.IO/XlsxChartXmlWriter.Series.cs)): numeric X-axis data (years, values) becomes a text/category axis after one round-trip. Emit `<c:numRef>` when the source range is numeric.
- **`refreshOnLoad` read with `defaultValue: true`** ([`XlsxPivotCacheReader.cs:58`](../../src/FreeX.Core.IO/XlsxPivotCacheReader.cs#L58), verified inline): OOXML default is false — every pivot cache without the attribute round-trips into forced refresh-on-open (credential prompts / failures with external sources).
- **Pivot cache shared items re-typed from string sniffing** ([`XlsxPivotTableWriter.Cache.cs:143`](../../src/FreeX.Core.IO/XlsxPivotTableWriter.Cache.cs#L143)): text values like "001" become `<n>` on save, breaking filter/slicer item matching. Preserve the original item type.
- **chartEx axes only emitted for Pareto/BoxWhisker/Waterfall** ([`XlsxChartXmlWriter.ChartEx.cs:175`](../../src/FreeX.Core.IO/XlsxChartXmlWriter.ChartEx.cs#L175)): Histogram/Funnel/Treemap/Sunburst lose axis elements and Y-axis scaling entirely.
- **Pivot cache records relationship id hardcoded** (`"rIdPivotCacheRecords"`, [`XlsxPivotTableWriter.cs:44`](../../src/FreeX.Core.IO/XlsxPivotTableWriter.cs#L44)): multi-cache workbooks collide.
- P3: legacy comment authors dropped ([`XlsxWorksheetCommentReader.cs:87`](../../src/FreeX.Core.IO/XlsxWorksheetCommentReader.cs#L87)); threaded-comment part paths derived from sheet list index → reordering sheets orphans parts ([`XlsxWorksheetThreadedCommentMapper.cs:88`](../../src/FreeX.Core.IO/XlsxWorksheetThreadedCommentMapper.cs#L88)); multi-area series range formulas unparsed → positional fallback rewrites chart data ([`XlsxChartSeriesRangeReader.cs:80`](../../src/FreeX.Core.IO/XlsxChartSeriesRangeReader.cs#L80)); per-axis title formatting collapsed to shared chart-level fields ([`XlsxChartXmlWriter.Axes.cs:46`](../../src/FreeX.Core.IO/XlsxChartXmlWriter.Axes.cs#L46)).

### P2 - `.fxl` fidelity gaps now matter doubly (crash-recovery format)

[`NativeJsonAdapter.Dto.cs`](../../src/FreeX.Core.IO/NativeJsonAdapter.Dto.cs#L438) has `IsHidden` but no `IsVeryHidden` (verified by grep: the property exists in XLSX adapters, not in the fxl DTO) — a veryHidden sheet recovered after a crash becomes user-unhideable-visible. Since autosave/recovery routes every crash through `.fxl`, ANY state the DTO drops is silently lost on the worst day. Action: add `IsVeryHidden`, then write a **fidelity inventory test** that round-trips a maximal workbook through NativeJsonAdapter and diffs model state field-by-field, so future model additions fail the test until serialized.

### P2 - Find/Replace cluster

- **Modeless dialog follows workbook swaps** ([`MainWindow.WorkbookUiState.cs:293`](../../src/FreeX.App.Host/MainWindow.WorkbookUiState.cs#L293)): the `() => _workbook` closure means Replace All after an open/drag-drop silently modifies the NEW file (finder-verified). Close or rebind the dialog on workbook change.
- **Formulas-mode replace keeps the stale cached `Value`** ([`FindReplaceService.cs:325`](../../src/FreeX.Core.Commands/FindReplaceService.cs#L325)): replaced formula text displays the old result until an unrelated recalc (finder-verified; check whether the host's post-replace recalc covers all paths — if it does, document it; if not, clear Value).
- P3 cross-sheet chart shift gap: [`ShiftChartRowsUp`](../../src/FreeX.Core.Commands/RowColumnShiftHelpers.PrintAndCharts.cs#L41) only iterates the modified sheet's charts; charts on other sheets referencing the modified sheet (possible via XLSX load) keep stale ranges.

## 4. Formula Parity

### 4.1 Confident findings (evidence verified against Excel semantics)

- **P3 XIRR missing sign validation** ([`BuiltInFunctions.Financial.CashFlow.cs:67`](../../src/FreeX.Core.Formula/BuiltInFunctions.Financial.CashFlow.cs#L67)): no positive+negative cash-flow check (IRR has one at line ~209); all-positive inputs iterate instead of returning `#NUM!` deterministically.
- **P3 IRR has no bisection fallback**: Newton overshoot below −1 NaNs out to `#NUM!` for inputs Excel converges on; add the bracketing fallback Excel-compatible implementations use.
- **P3 FIXED blank-decimals fallback is 0, Excel default is 2** ([`BuiltInFunctions.TextCore.Format.cs:75`](../../src/FreeX.Core.Formula/BuiltInFunctions.TextCore.Format.cs#L75)): reachable via broadcast with a blank decimals cell.
- **P3 fraction-format alignment padding** dropped when the fraction rounds away ([`NumberFormatter.Fractions.cs:61`](../../src/FreeX.Core.Formula/NumberFormatter.Fractions.cs#L61)).
- **P3 FILTER with scalar/mismatched include** returns `#VALUE!` for shapes that need checking against Excel's broadcast rules — and the 1-row include path indexes `include.Cells[i,0]` beyond bounds for multi-row arrays per the finder's trace ([`BuiltInFunctions.DynamicArrays.FilterSort.cs:17`](../../src/FreeX.Core.Formula/BuiltInFunctions.DynamicArrays.FilterSort.cs#L17)) — the potential out-of-bounds read is worth a hardening test regardless of parity.

### 4.2 VDB switch-point arithmetic (needs oracle)

[`BuiltInFunctions.Financial.Depreciation.cs:150`](../../src/FreeX.Core.Formula/BuiltInFunctions.Financial.Depreciation.cs#L150) computes the SLN-switch denominator from `floor(currentPeriod)` — plausible divergence for fractional start/end periods; verify against Excel via the fidelity tool before changing.

### 4.3 Finder claims REFUTED during verification (recorded so they are not re-reported)

- `TIME(-1,0,0)`: Excel also returns `#NUM!` for negative components — FreeX matches Excel; no change.
- `DATEDIF "MD"` borrowing days from the month before the end date matches Excel's actual (documented-as-unreliable) behavior; the claimed "Excel uses start month" is wrong.
- `YEARFRAC` basis-0 NASD ordering and basis-1 averaging, and the NumberFormatter single-section sign-prefix placement: the claimed Excel outputs are unverified or likely wrong (Excel's NASD Feb rule requires BOTH dates at Feb-end; Excel prepends the minus before prefix literals). These belong in the **FidelityCompare oracle corpus** (`tools/FreeX.FidelityCompare`): add YEARFRAC/DATEDIF/TEXT-format cases there and let real Excel arbitrate.

## 5. Performance

- **P2 workbook.xml parsed 3× per load** ([`XlsxFileAdapter.cs:~1006`](../../src/FreeX.Core.IO/XlsxFileAdapter.cs#L1006), verified: 3 `GetEntry("xl/workbook.xml")` + parse sites): parse once, pass the XDocument to all three inspectors.
- **P2 full save runs 39 normalize passes, each rescanning archive entries and re-parsing worksheet XML** ([`XlsxFileAdapter.SourcePackage.cs:78`](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackage.cs#L78), verified: 39 `NormalizeWorksheets/NormalizePackage` calls): for a 20-sheet workbook ≈ 780 entry scans + XDocument loads per save. This is the *performance* face of the sanitizer-treadmill altitude finding: a single-pass table-driven normalizer fixes both.
- **P2 O(N²) rels traversal per save** ([`XlsxFileAdapter.SourcePackage.cs:228`](../../src/FreeX.Core.IO/XlsxFileAdapter.SourcePackage.cs#L228)): compute the retained-targets union once, subtract per sheet.
- **P2 formula-bar reference highlighting allocates N WPF Borders + layout passes per keystroke** ([`MainWindow.FormulaReferenceEditing.cs:260`](../../src/FreeX.App.Host/MainWindow.FormulaReferenceEditing.cs#L260)): pool the 6 palette Borders.
- P3: Find converts every number cell to string even when the pattern can't match a number ([`FindReplaceSearchPlanner.cs:149`](../../src/FreeX.Core.Commands/FindReplaceSearchPlanner.cs#L149)); autosave materializes the full DTO graph on the dispatcher before any IO ([`NativeJsonAdapter.Save.cs:34`](../../src/FreeX.Core.IO/NativeJsonAdapter.Save.cs#L34) — the documented `Workbook.Clone` gap); per-keystroke `List<char>` in quoted-sheet parsing; per-selection-change `string[6]` + LINQ in status automation; per-sheet style-index Dictionary churn on load ([`XlsxFileAdapter.cs:257`](../../src/FreeX.Core.IO/XlsxFileAdapter.cs#L257)).

## 6. Consistency And Reuse

- **P2 wildcard→regex duplicated without the cache** ([`AccessibilityCheckerService.Contrast.cs:~11213`](../../src/FreeX.Core.Commands/AccessibilityCheckerService.Contrast.cs) vs canonical [`BuiltInFunctions.Criteria.cs:257`](../../src/FreeX.Core.Formula/BuiltInFunctions.Criteria.cs#L257)): the copy allocates a fresh Regex per CF evaluation; consolidate (shared helper or InternalsVisibleTo).
- **P2 `SheetNameFormatter` stragglers**: [`XlsxChartXmlWriter.cs:477`](../../src/FreeX.Core.IO/XlsxChartXmlWriter.cs#L477) raw-escapes only apostrophes — a sheet named `TRUE` or `A1` is written unquoted into chart XML (real corruption case); [`FormulaSerializer.WriteSheetName`](../../src/FreeX.Core.Formula/FormulaSerializer.cs#L249) half-delegates (NeedsQuoting + inline escape). Route both through `QuoteIfNeeded`.
- **P2 three hex-color parsers** ([`ColorInputParser.cs:60`](../../src/FreeX.App.Host/ColorInputParser.cs#L60), [`NativeJsonColorMapper.cs:10`](../../src/FreeX.Core.IO/NativeJsonColorMapper.cs#L10), canonical [`XlsxColorReader.cs:9`](../../src/FreeX.Core.IO/XlsxColorReader.cs#L9)) — already drifting on whitespace handling.
- P3: two more private column-name implementations (ScreenshotTour targets, [`PortablePdfTextCapabilityPlanner.cs:190`](../../src/FreeX.App.Services/PortablePdfTextCapabilityPlanner.cs#L190)); [`SheetNameDialog`](../../src/FreeX.App.Host/SheetNameDialog.cs#L36) re-implements name validation rule-by-rule instead of calling `Workbook.ValidateSheetName`; one-line quoting wrappers in WorkbookReferenceNavigator/PivotUiPlanner; raw English strings passed to `_messageService` in the window-management commands ([`MainWindow.MultiWindow.cs:243`](../../src/FreeX.App.Host/MainWindow.MultiWindow.cs#L243) etc., verified inline — and the localization guard test evidently does not cover these files).

## 7. Architecture And Gaps

### P2 - The Avalonia macOS port is an unmanaged fork (new finding)

[`src/FreeX.App.Avalonia/MainWindow.cs`](../../src/FreeX.App.Avalonia/MainWindow.cs) is ~14,500 lines in a single file with its own raw `_isOpening`/`_isSaving`/dirty handling on `WorkbookSession` — none of the save-race/close-flow/generation-counter fixes apply to it; macOS users have the original P1 save-race semantics. It is in `FreeX.slnx` (Windows lane compiles it) but the macOS portable CI lane builds only `FreeX.DefaultTests.slnx` — an Avalonia-only break passes macOS CI. There is no test project (only 8 string-asserting source tests in `AvaloniaShellSourceTests.cs`), no architecture-doc entry, no localization (≈300 hard-coded English strings, duplicated enums like `MergeCellsWarningChoice`). Recommended sequence: (1) add `FreeX.slnx` build to the macOS CI lane; (2) decide the sharing strategy — move portable logic (planners, document state, save flows) into App.Services and consume it from both hosts rather than forking; (3) port the close/save fixes; (4) create a behavioral test project; (5) document the project in architecture.md.

### Carry-forward: MainWindow god object — got bigger

Now **81 partial files / 53,599 lines** (was 53/26.5K at the 06-11 review; ScreenshotTour partials account for a large share). The `WorkbookDocumentState` seam worked; next extractions in value order: formula-bar state cluster (~9 fields), pivot UI state (~5 fields), ribbon adaptive cache (~7 fields) — all WPF-light and testable in App.Services. Also consider relocating ScreenshotTour partials out of the production window class entirely (they are dev/CI tooling).

### Carry-forward: sanitizer migration stalled at 8 of 17

Nine workbook normalizers remain bespoke; all need child-element policies (`ChildElementAllowedNames` + required-attribute rules) added to [`XlsxWorkbookElementSchema`](../../src/FreeX.Core.IO/XlsxWorkbookElementSchema.cs) before they can migrate (`functionGroups` is the easiest first). The orchestrator grew to ~2,394 lines, and section 5's 39-pass save shows the runtime cost of the remaining shape. The table extension + a single-pass driver addresses correctness, maintainability, and save performance together.

### Other carry-forward and gaps

- **Hygiene-test altitude: drifting the wrong way** — `AvaloniaShellSourceTests.cs` is a NEW string-asserting source-test file added since the review. Convention proposal needed (behavioral tests for new code; string tests only for text artifacts), else every new project imports the pattern.
- **Flaky perf gate**: `RepeatedBooleanCoercion...` (line ~172) AND its sibling `RepeatedComparison...` (line ~139) are plain `[Fact]` wall-clock/allocation tests in the gating lane while `[BenchmarkFact]` exists for exactly this; convert both.
- **architecture.md lists 7 projects; src/ has 9** — App.Services (87 files, now hosting document state/autosave/save services) and App.Avalonia are absent; the App.Host description still claims it owns dirty state.
- **Resolved by other sessions (verified)**: satellite-resx parity (43 cultures, `7e65e5942`), UI-lane contracts (`5e2f6a840`), CI builds `FreeX.slnx` with concurrency, `FreeX.App.Host.Logic.Tests` gating, `_isOpeningFile` guard fix present.
- **Column-default styles**: still absent (verified) — unchanged deliberate defer.
- **Autosave deferred bits**: background-thread serialize still blocked on missing `Workbook.Clone`; interval not options-configurable; multi-candidate recovery now also a correctness bug (section 2).

## 8. Carry-Forward Status Summary

| 2026-06-11 deferred item | Status on 1fe1b2644 |
|---|---|
| MainWindow extraction | Seam proven (WorkbookDocumentState); object grew to 81 files / 53.6K lines; next seams named |
| Sanitizer schema-table migration | 8/17 migrated; blocked on child-element table support; orchestrator 2,394 lines |
| Hygiene-test altitude | Unchanged + one NEW string-test file added (Avalonia) — needs a convention decision |
| Column-default styles | Still absent; used-range clamp shipped (with the empty-column regression in section 2) |
| Flaky perf test gating | Still `[Fact]`; sibling has same issue; convert to `[BenchmarkFact]` |
| Autosave deferred bits | Clone-less UI-thread serialize unchanged; multi-candidate handling now a bug (section 2) |
| UI-lane satellite/localization failures | RESOLVED by `7e65e5942` / `5e2f6a840` |
| CI FreeX.slnx + concurrency + logic-tests gating | RESOLVED (residual: macOS lane doesn't compile Avalonia) |

## 9. Clean Signals Worth Recording

- All 2026-06-11 findings and both fix-campaign passes remain in place on current `main`; spot-checks of the save-race guard, `_isOpeningFile`, escaping, and consolidations all verified present.
- The four most recent main merges (recovery satellite parity, UI-lane contracts, formula-bar point mode, recovery preserved gaps) audited; no removed-behavior issues found.
- Layering remains clean; central package management active with no version skew; no vulnerable packages reported in the last scan.
- The default gating lane now carries 12,500+ tests including 1,411 host-logic tests that previously ran only in the flaky UI lane.

## 10. Verification Commands

```powershell
git status --short --branch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build
```

Documentation-only review; results recorded in the review log entry.
