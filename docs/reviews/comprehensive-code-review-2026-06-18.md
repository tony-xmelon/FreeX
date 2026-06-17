# FreeX Comprehensive Code Review - 2026-06-18

## 0. Method And Coverage

Read-only whole-repo review at `main` HEAD `d68d140b1` ("Linux parity: merge variants, paste special, more-colors, data tools, sheet options, show notes"). Seven independent finder passes were fanned out over non-overlapping scopes so the ~442k LOC in `src/` could be covered concurrently:

| Pass | Scope | LOC |
|---|---|---|
| 1 | `FreeX.Core.Formula` (parser, tokenizer, AST, function library) | ~33k |
| 2 | `FreeX.Core.Calc` (recalc/dependency engine) + `FreeX.Core.Model` (workbook/sheet/cell model) | ~15k |
| 3 | `FreeX.Core.IO` + `Free.Shared.Opc` (xlsx/csv/fxl read-write, OPC/zip, XML) — security-weighted | ~95k |
| 4 | `FreeX.Core.Commands` (editing commands + undo/redo) | ~80k |
| 5 | `FreeX.App.Host` (WPF host, lifecycle, Velopack, Sentry, print/export) | ~140k |
| 6 | `FreeX.App.Services` + `FreeX.App.UI` + `FreeX.App.Presentation` | ~52k |
| 7 | Shared tier + `FreeX.App.Avalonia`/`Ribbon.Avalonia` + build/dependency config | ~42k |

Every reported finding was verified by reading the actual source, not by grep alone. Each pass was also asked to record candidates it investigated and **dismissed** as non-issues; those are summarized in section 7 so a future reviewer does not re-spend effort on them.

Scope limit: this is a static review. No tests were run as part of it; the default lane was green at the prior review (2026-06-12). `freew/` (the sibling `.docx` app) was out of scope for this pass.

## 1. Executive Summary

The codebase is, overall, **unusually disciplined**. The untrusted-file attack surface (the thing that matters most for a spreadsheet app) is well defended; number/date parsing in the formula engine is consistently invariant-culture; recursion is bounded; most `catch` blocks deliberately convert to Excel error values rather than swallowing. No Critical defects were found. The findings cluster into a few themes:

1. **Command atomicity under exceptions is the biggest correctness gap.** `CommandBus.Execute` does not guard `Apply`, so a command that throws mid-mutation leaves the workbook half-edited with nothing on the undo stack. `CompositeWorkbookCommand` has the same hole for a thrown inner command (it only rolls back on `Success==false`).
2. **Incremental recalc can leave stale values around spills.** The spill-target dependent re-evaluation pass is wired only into full recalc, not the per-edit path, so formulas reading a spill range (`=SUM(C2#)`, `=B3` over a spilled cell) can read stale data until a full recalc.
3. **Privacy: Sentry transmits raw exception messages and stack traces**, which embed local file paths (`C:\Users\<username>\...`) even though `SendDefaultPii=false`. The local crash store is path-allowlisted; the remote path is not.
4. **CSV/delimited import is locale-dependent and unbounded.** Numbers and dates are parsed with `CurrentCulture` first (same file → different values per machine locale), and the whole stream is buffered with no size guard (the zip-path size guard does not cover CSV/fxl).
5. **The Avalonia (macOS/Linux) app has parity gaps with the WPF host**: no Windows `app.manifest` (no DPI awareness), macOS-only RIDs, no stamped assembly version (reports `1.0.0` to crash analytics + update gating), and `async void` handlers that `await` I/O without a top-level try/catch.
6. **Dependency hygiene**: `Sentry 6.5.0` and `Velopack 1.2.0` are the most behind for runtime-critical components; `FluentAssertions 8.x` carries a commercial-license cost risk. No known critical CVE at the pinned versions.
7. **Shared file stores are not thread-safe** (`AppDiagnosticsFileStore`, `RecentFilesStore`) yet are reachable from crash/background threads.

Severity legend below: **High** = correctness/privacy bug that can cause data loss, wrong results, or info disclosure in normal use; **Medium** = real defect with narrow trigger or non-fatal impact; **Low** = robustness/maintainability/edge-case.

---

## 2. Findings — Core Engine (Formula / Calc / Model)

### High

**[High] Incremental recalc does not refresh formulas that read spill targets**
`src/FreeX.Core.Calc/RecalcEngine.cs:438-446` (only in `RecalculateAllFormulas`)
The second pass re-evaluating formula cells that read spill-target cells (`CollectSpillTargetDependentFormulaCells`) is wired only into `RecalculateAllFormulas`, not the per-edit `Recalculate(workbook, changedCells)` path (lines 39-189). Spill targets are not formula cells and have no dependency-graph node, so after a normal edit that changes a spill anchor's extent/values, `=SUM(C2#)` / `=B3` over a spilled cell keeps a stale value until a full recalc.
Fix: run the spill-target dependent second pass inside `Recalculate` too, or model spill targets as graph nodes.

**[High] Newly edited formula's precedent edges are registered after the recalc order is computed**
`src/FreeX.Core.Calc/RecalcEngine.cs:45-46, 103-119`
`GetRecalcOrder` is computed from the *old* graph; a just-edited formula's new precedents are only registered inside the eval loop. If the same edit batch also dirties cells that are new precedents of the edited formula, the topological order can run the edited formula before those precedents.
Fix: register dependencies for changed formula cells before computing the recalc order.

**[High] Partial range-endpoint deletion yields #REF! instead of shrinking the range**
`src/FreeX.Core.Formula/FormulaRewriter.cs:185-192` (and the range-move / full-row/col variants)
`RewriteRange` rewrites `Start`/`End` independently; if only the start endpoint of `A5:A10` falls in deleted rows 5-7, the start becomes an `ErrorNode` and the whole range collapses to `#REF!`. Excel instead shrinks the range and only errors when the *entire* range is deleted. This silently breaks formulas after a very common edit.
Fix: when only one endpoint is inside the deleted band, clamp it to the band edge (shrink); emit `#REF!` only when both endpoints are deleted.

### Medium

**[Medium] Sheet.Clone drops all spill state**
`src/FreeX.Core.Model/Sheet.Clone.cs:147-156`
`CopyCellContentTo` copies `_cells`, style-only entries, and merges but never `_spillValues`, `_spillAnchors`, or `_provisionalSpillCells`. A duplicated sheet shows blank spill ranges and loses `TryGetSpillExtent` until a recalc reruns; a non-recalculating caller loses spilled array results entirely.
Fix: copy the spill dictionaries (remapped to the new sheet id) in `CopyCellContentTo`.

**[Medium] Sheet removal leaves dangling named formulas**
`src/FreeX.Core.Model/Workbook.cs:402-409`
`RemoveNamedRangesForSheet` prunes `NamedRanges`/metadata for the deleted sheet but leaves `NamedFormulas` referencing it, and doesn't reconcile `NamedRangeMetadataByName` for names that exist only as formulas. Deleting a sheet can leave named formulas resolving against a non-existent sheet.
Fix: also reconcile `NamedFormulas` (and metadata) on sheet removal.

**[Medium] `Workbook.GetStyle` clones on every access (hot-path allocation)**
`src/FreeX.Core.Model/Workbook.cs:473-477`
`GetStyle` returns `…Clone()` every call. Viewport rendering and CF evaluation call style lookup per visible cell, so each repaint allocates a fresh `CellStyle` per cell.
Fix: return the stored immutable instance (callers treat it as read-only) or cache clones.

**[Medium] `ConcurrentDictionary.Count` on the wildcard hot path + racy `Clear()`**
`src/FreeX.Core.Formula/FormulaWildcardHelper.cs:35-39`
`GetOrCreateRegex` calls `Cache.Count` (locks every bucket) per invocation, and the check-then-`Clear()` races (can clear a cache another thread just filled). This is on the COUNTIF/SUMIF/SEARCH hot path.
Fix: track an approximate count with `Interlocked`, or only check inside the `GetOrAdd` factory; avoid `Clear()` under contention.

**[Medium] Unsynchronized `_sheetNameCache` write if an evaluator is shared across threads**
`src/FreeX.Core.Formula/FormulaEvaluator.Contexts.cs:147-153`
`ResolveSheet` lazily creates/writes a plain `Dictionary` with no lock. The single-sheet context is cached on the `FormulaEvaluator` instance, so a parallel recalc on one instance can corrupt the dictionary (torn buckets / infinite loop).
Fix: document `FormulaEvaluator` as single-thread-per-instance, or make `_sheetNameCache` a `ConcurrentDictionary`.

**[Medium] Broad `catch { return ErrorValue.Num; }` in date/time functions masks real bugs**
`src/FreeX.Core.Formula/BuiltInFunctions.DateTime.cs:97, 261, 468, 497` (also `InformationA2.cs:414`)
These bare catches swallow `NullReferenceException`/`IndexOutOfRangeException` from genuine logic errors and turn them into cell errors, so defects surface as silent wrong results rather than test failures.
Fix: narrow to the expected `ArgumentOutOfRangeException`/`OverflowException` (as already done at lines 331/344).

### Low

- **[Low] `INFO("directory")` exposes `Environment.CurrentDirectory`** — `BuiltInFunctions.InformationA2.cs:412-414`. Minor info disclosure to untrusted formulas; empty-catch also hides permission errors.
- **[Low] `MaxEvalDepth=256` is ≤ the parser nesting cap**, so a legitimately deep but valid formula / depth-~256 recursive LAMBDA returns `#NUM!` though Excel would compute it — `src/FreeX.Core.Formula/FormulaEvaluator.cs:19,167-168`.
- **[Low] `INDEX(range, n)` over a 2-D range** doesn't apply Excel's linear/row-selector semantics in the 2-arg branch — `FormulaEvaluator.References.cs:425-448`.
- **[Low] `RebuildFormulaDependencies` aborts the whole rebuild on an unexpected exception**, leaving the graph partially populated — `RecalcEngine.cs:405-418`.
- **[Low] `MoveSheet`/`InsertSheet` index `_sheets` directly**; bad index throws a raw `ArgumentOutOfRangeException` and `MoveSheet` can leave the list half-modified — `Workbook.cs:280-295, 483-492`.
- **[Low] `RangeValue.At/GetColumn/GetRow` do no bounds checking** (a `0` arg underflows to `-1`) — `ScalarValue.cs:61-78`.
- **[Low] `GoalSeek` restore re-inserts a cloned formula cell without re-registering its dependencies** when the changing cell originally held a formula — `GoalSeekService.cs:26, 90-106`.
- **[Low] `GetStyleOnlyEntries` can emit a duplicate key** when a run merge moves an overlay inside a differently-styled run — `Sheet.StyleOnly.cs:105-139`.

---

## 3. Findings — Editing Commands & Undo/Redo

### High

**[High] `CommandBus.Execute` does not catch exceptions from `Apply` — model left half-mutated**
`src/FreeX.Core.Commands/CommandBus.cs:32-46`
`Undo`/`Redo` wrap their work in try/catch with rollback (lines 67-76, 92-110) but `Execute` calls `command.Apply(ctx)` unguarded. A command that mutates incrementally (delete rows, insert cells, rewrite formulas) and throws mid-way leaves the workbook partially mutated AND pushes nothing to the undo stack, so the user cannot revert. This is the single largest atomicity risk in the subsystem.
Fix: wrap `Apply` in try/catch; on exception attempt `Revert` and return a failure outcome instead of propagating with the model dirty.

**[High] `CompositeWorkbookCommand.Apply` does not roll back on a *thrown* inner command**
`src/FreeX.Core.Commands/CompositeWorkbookCommand.cs:26-38`
The loop only calls `RevertApplied` when an inner outcome returns `Success==false`. If an inner `Apply` *throws*, the exception escapes before rollback, leaving applied sub-commands committed. Multi-step operations (merge variants, paste-special pipelines) built on this type are non-atomic on exception.
Fix: wrap the loop body in try/catch and `RevertApplied(ctx)` before rethrowing/returning failure.

### Medium

- **[Medium] Insert-rows/cols boundary guard ignores the insertion point** — only checks occupied data, so an empty sheet with a `_beforeRow`/`_beforeCol` near the sheet limit can shift addresses past the limit — `InsertDeleteRowsCommand.cs:46-48`, `InsertDeleteColumnsCommand.cs:46-48`.
- **[Medium] Formula undo snapshot couples to object identity** — `RewriteAllFormulas`/`RestoreFormulas` store only the original text and restore by re-looking-up the same `Cell` instance, relying on strict revert ordering (the code even carries a "Do NOT reorder" comment) — `RowColumnShiftHelpers.Formulas.cs:8-36`.
- **[Medium] Redo re-runs `Apply`** (re-capturing snapshots from live state); correct only if undo restored state exactly, so it amplifies the atomicity findings above — `CommandBus.cs:82-116`.

### Low

- **[Low] Heavy duplication across the six row/column command classes** (near-identical capture/move/snapshot logic; merge-shrink is inlined for rows but extracted for columns — divergent implementations of the same rule) — `InsertDeleteRowsCommand.cs`, `InsertDeleteColumnsCommand.cs`, `DeleteRowsCommand.cs`.
- **[Low] `RemoveDuplicateRowsCommand` snapshots the entire range** even when only trailing rows change (O(rows×cols) allocation) — `RemoveDuplicateRowsCommand.cs:70-79`.

---

## 4. Findings — I/O (xlsx / csv / fxl / OPC)

**Security posture (verified — already well defended):**
- **XXE:** every `XmlReader` uses `DtdProcessing.Prohibit` + `XmlResolver=null`, centralized in `shared/Free.Shared.Opc/SecureXmlReaderSettings.cs` (~25 call sites). XSLT disables document/script functions and bounds output. No gap found.
- **Zip-slip / path traversal:** no filesystem writes use package-derived names anywhere in scope (zero `ExtractToFile`/`ExtractToDirectory`/`File.Create`-with-entry-name matches). Zip entry names and relationship targets are only consumed via in-memory `archive.GetEntry(...)`. `ResolveRelationshipTarget`'s `../` resolution feeds `GetEntry`, never the filesystem. Not exploitable.
- **Zip bomb / oversized xlsx:** `WorkbookOpenSizeGuard` checks declared decompressed total (8 GiB), compression ratio (1000:1), and rejects duplicate entry names before heavy decompression; `MaxCharactersInDocument` (64 MiB) caps per-part reads.
- **CSV export injection:** the writer prefixes `=+-@` text with `'` (`DelimitedTextWorkbookWriter.cs:290-298`). Defended.

### Medium

- **[Medium] CSV/delimited load buffers the whole stream with no size guard** — `stream.CopyTo(new MemoryStream())`; the zip-path size guard does not cover `.csv`/`.fxl`, so an arbitrarily large delimited file is an unbounded-allocation DoS — `DelimitedTextWorkbookReader.cs:356-357` (entry `CsvFileAdapter.cs:18`).
- **[Medium] CSV number import is locale-dependent** — `TryParseFiniteNumber` tries `CurrentCulture` before `InvariantCulture` with `NumberStyles.Any`, so `"1,234"` differs per locale; import is non-deterministic across machines — `DelimitedTextWorkbookReader.cs:651-653`.
- **[Medium] CSV date import is locale-dependent** — `DateTime.TryParse(..., CurrentCulture)` runs before the invariant explicit-format list, so `01/02/2024` imports as Jan 2 vs Feb 1 by locale — `DelimitedTextWorkbookReader.cs:479,492-507`.
- **[Medium] Unbounded column growth per CSV record** — a single line with millions of delimiters doubles the field array without bound — `DelimitedTextWorkbookReader.cs:~275-281`.
- **[Medium] UTF-8 decode failure silently falls back to Windows-1252** — always "succeeds" and can mojibake non-Western text with no warning — `DelimitedTextWorkbookReader.cs:407-416`.

### Low

- **[Low] `.fxl` native parse failures swallowed with no warning** (silent loss of print areas, merged regions, addresses, named ranges) — `NativeJsonAdapter.cs:164,240,271,337,355,390-391,431,458`. Unlike the xlsx loader, no `warnings.Add`.
- **[Low] Native preserved-XML metadata dropped on malformed input without warning** — `XmlNativeBagSerializer.cs:~40-41,54,89,149-150`.
- **[Low] Bare `catch { return ErrorValue.Num; }` on cell-value coercion** swallows non-data exceptions and emits no warning — `XlsxClosedXmlCellMapper.cs:68`.
- **[Low] Bare `catch` in the conditional-format-stripping fallback** records nothing about why the prior attempt failed — `XlsxFileAdapter.cs:~1517-1523`.

---

## 5. Findings — WPF Host & App/UI Layers

### High

**[High] Sentry sends raw exception messages/stack traces — leaks local file paths (incl. usernames)**
`src/FreeX.App.Host/SentryCrashAnalytics.cs:22-29, 49-59`
`SetBeforeSend` only adds tags; it never scrubs the event. `CaptureException` transmits `exception.Message` + stack trace verbatim. Workbook open/save failures (`IOException`, `FileNotFoundException`, path-parse) embed the full local path — typically `C:\Users\<username>\...` — so usernames and document names reach Sentry despite `SendDefaultPii=false`. The local crash store is path-allowlisted; the remote path is not.
Fix: in `SetBeforeSend`, redact the message/exception values and stack-frame paths (strip the user profile dir; drop `ex.Message` for file-IO exception types) before returning the event.

### Medium

- **[Medium] `ApplyAndRestart` makes a synchronous network call on the UI thread** — `Apply()` runs the blocking `manager.CheckForUpdates()` (GitHub round-trip) directly from a click handler, freezing/hanging the UI; the update was already downloaded so the re-check is also redundant — `src/FreeX.App.Services/Updates/VelopackUpdateService.cs:66-73` (from `MainWindow.Update.cs:40`).
- **[Medium] Background update-check resolves DI services / captures `mainWindow` off-thread during startup** — `App.xaml.cs:150-162`. Marshal references on the UI thread before `Task.Run`.
- **[Medium] App-level crash-handler subscriptions are process-global with captured state and no double-registration guard** — `App.xaml.cs:250-266`.
- **[Medium] Marching-ants `DispatcherTimer` can outlive the grid if `Unloaded` never fires** — the `Tick` closure captures `this`, rooting the whole `GridView`; window-closed-without-unload is the gap — `src/FreeX.App.UI/GridView.State.cs:243-249`.

### Low

- **[Low] Non-event-handler `async void` helpers** (exceptions escape to the dispatcher → crash) — `MainWindow.QuickAccessToolbar.cs:451`, `MainWindow.ScreenshotTour.cs:209`.
- **[Low] Declined/failed recovery-snapshot deletion silently swallowed** — same crash snapshot re-offered every launch if deletion keeps failing — `App.xaml.cs:412-418, 440-444, 452`.
- **[Low] `AutosaveService` doc says "timer-driven" but owns no timer; `Dispose` only flips a flag** — misleading; a maintainer may assume disposing stops autosave (it doesn't) — `src/FreeX.App.Services/AutosaveService.cs:31,162-165`.
- **[Low] Several intentionally-broad `catch { }` blocks rely on convention not typed filters** — `ChartRenderer.cs:753`, `WpfBitmapImageLoader.cs:25`, `WorkbookReferenceNavigator.cs:128`, `DataValidationDropdownPlanner.cs:54,129`, `RemoveDuplicatesPlanner.cs:187`.

---

## 6. Findings — Shared Tier, Avalonia App & Build Config

### High

**[High] Shared file/JSON stores are not thread-safe but are reached from crash/background threads**
`shared/Free.Shared.AppServices/AppDiagnosticsFileStore.cs:53`, `RecentFilesStore.cs:45,211`
`RecordEvent` does `File.AppendAllText` with no lock; the diagnostics handlers are wired to `AppDomain.UnhandledException` / `TaskScheduler.UnobservedTaskException`, which fire on arbitrary threads — concurrent appends interleave/throw (swallowed) and lose crash data. `RecentFilesStore` mutates a shared `List` + rewrites the file with no sync.
Fix: guard the append/save and list mutations with a lock (or a serialized writer).

**[High] Avalonia `async void` event handlers `await` I/O with no top-level try/catch**
`src/FreeX.App.Avalonia/MainWindow.cs:12707` (`MainWindow_Drop`), `:13967` (`MainWindow_Closing`), `MainWindow.MoreColors.cs:30,40`
`OpenWorkbookPathAsync` only catches a *filtered* set (`MainWindow.cs:14337`); an exception outside that set, or from `CreateIdentityAsync`/the dialog, escapes the `async void` to the dispatcher and tears down the app.
Fix: wrap each `async void` body in try/catch routing to `ShowOpenIssue`/diagnostics.

**[High] Avalonia desktop app ships no Windows `app.manifest` — no DPI awareness / long-path opt-in**
`src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj:42-43`
It compiles to `net10.0` (RID-agnostic) + `net10.0-macos` — i.e. the cross-platform host that also runs on Windows/Linux — yet ships no manifest (the WPF host has `app.manifest` with PerMonitorV2). On Windows it runs system-DPI-unaware (blurry on high-DPI) with no `longPathAware`.
Fix: add an `app.manifest` with PerMonitorV2 + `longPathAware` and reference it via `<ApplicationManifest>` for the Windows build.

### Medium

- **[Medium] Avalonia app declares only macOS RIDs** (`osx-arm64;osx-x64`) though built/published for Windows & Linux too — no `win-x64`/`linux-x64` for self-contained publish or Velopack packaging — `FreeX.App.Avalonia.csproj:40`.
- **[Medium] No version stamped on the Avalonia assembly** — defaults to `1.0.0.0`; `AvaloniaAppDiagnostics` and the Velopack check read assembly version, so crash reports and update gating report a bogus `1.0.0` (WPF host sets `0.5.0`) — `FreeX.App.Avalonia.csproj`.
- **[Medium] `Nullable`/`ImplicitUsings` set per-project, not centrally** — every csproj repeats it; a new project silently loses nullable enforcement — `Directory.Build.props:1-7`.
- **[Medium] `UndoRedoStack<,>` (promoted as reusable) is not thread-safe and throws raw exceptions on empty pop** — `shared/Free.Shared.Commands/UndoRedoStack.cs:87-96`.
- **[Medium] `App.cs` subscribes `IActivatableLifetime.Activated` with an `async void` lambda, never detached** — exceptions crash the app — `src/FreeX.App.Avalonia/App.cs:42`.

### Low

- **[Low] No analyzers raised despite warnings-as-errors** — `EnforceCodeStyleInBuild=true` but no `AnalysisLevel`/`AnalysisMode` — `Directory.Build.props:1-7`.
- **[Low] `AtomicFileWriter` isn't crash-atomic** — temp + `File.Move(overwrite)` with no flush and no `File.Replace` backup — `shared/Free.Shared.AppServices/AtomicFileWriter.cs:20-21`.
- **[Low] Static unhandled-exception handlers registered, never unregistered** — `AvaloniaAppDiagnostics.cs:31-36`.
- **[Low] Avalonia `App` exposes mutable static startup state** (`StartupArguments`, `Diagnostics`, `LaunchSmokeOptions`) — defeats testability — `src/FreeX.App.Avalonia/App.cs:11-15`.
- **[Low] macOS share-sheet service overwrites retained `NSObject` fields without releasing** — `MacOs/MacOsWorkbookShareSheetService.cs:13,46,50`.
- **[Low] WPF host manifest declares no `supportedOS`/`maxversiontested`** — OS may apply compat shims — `src/FreeX.App.Host/app.manifest:25-30`.

### Dependency inventory (`Directory.Packages.props` — central management on, all pinned exact)

| Package | Version | Note |
|---|---|---|
| Avalonia (+ Desktop/Headless/Fonts.Inter/Themes.Fluent) | 12.0.4 | Current major; consistent across all five. OK. |
| ClosedXML | 0.105.0 | Recent. |
| DocumentFormat.OpenXml | 3.1.1 | Current 3.x. OK. |
| ExcelDataReader | 3.8.0 | Latest. |
| Microsoft.Extensions.* (DI/Logging) | 10.0.7 | Matches .NET 10. OK. |
| OxyPlot.Wpf | 2.2.0 | Last of the 2.x line; stable but unmaintained; WPF-only (Windows). |
| PDFsharp-WPF | 6.2.4 | WPF-flavored; Avalonia uses its own `SkiaPdfDocumentExporter`. |
| SharpVectors.Wpf | 1.8.5 | WPF-only SVG; long-stable. |
| **Sentry** | **6.5.0** | Most behind of the runtime-critical deps; bump for fixes. |
| **Velopack** | **1.2.0** | Updater used by both hosts; newer patches exist; review. |
| Serilog (+ sinks/extensions) | 4.3.1 / 6.1.1 / 7.0.0 / 10.0.0 | Current. |
| **FluentAssertions** | **8.9.0** | 8.x is a **paid commercial license** for commercial use — cost risk, not a CVE. Consider pinning 7.x (last MIT) or an alternative. |
| xunit / runner / StaFact / Test.Sdk / coverlet | 2.9.3 / 3.1.4 / 1.2.69 / 17.14.1 / 6.0.4 | Test-only. OK. |

No package has a well-known critical CVE at these versions. Action-worthy: bump **Sentry** and **Velopack**; resolve the **FluentAssertions 8.x** license question.

---

## 7. Candidates Investigated And Dismissed (not defects)

Recorded so they aren't re-reviewed:

- **Operator precedence / associativity / blank coercion** in the formula engine all match Excel; `#DIV/0!`/`#NUM!` mapping for non-finite results is correct.
- **All `double.Parse`/`int.Parse` use `InvariantCulture`**; `ExcelTextNumberParser` uses fixed `en-US` with strict grouping — no locale drift in the engine (the locale issue is CSV-import-only, section 4).
- **Range/OFFSET/rewriter arithmetic widen to `long`** before bounds checks; cell counts capped at 1M — no integer overflow near sheet edges. `CellAddress` binary search uses overflow-safe midpoint.
- **AST nodes are immutable records** → safe to share from the parse cache across threads.
- **Cycle detection** (Kahn's algorithm) is correct; `ColumnNameCache` is correctly synchronized (`Volatile.Read` + `Interlocked.CompareExchange`); `IsSpillBlocked` uses `long` correctly.
- **`FillCellsCommand`/`AutofillCommand`** exclude the source edge from the target set (no overwrite-before-read); cell moves use a rent-clear-write three-pass via `ArrayPool` (no overwrite-during-shift); `SortCommand` has inverted-range/uint-underflow guards; delete merge math is correct.
- **IO:** `ZipArchive` update/load paths use `using` (dispose flushes) — no silent truncation; CSV writer defends against injection and intentionally omits the BOM.
- **WPF host:** inline-editor `+=` subscriptions are created once behind null-guards (not accumulating); autosave `DispatcherTimer` is `Stop()`-ped on `Closed`; production `.Result` hits were `dialog.Result` (a property), not `Task.Result`; print/XPS export uses correct nested `using` + atomic replace; external URLs go through a scheme allowlist; Velopack uses `GithubSource` over HTTPS with its own RELEASES/SHA verification.
- **App layers:** no `async void`, no blocking `.Result`/`.Wait()`, no DI registrations in `App.Services`/`App.UI`/`App.Presentation` (composition is in the host); the singleton-workbook + transient-window DI design is deliberate, not a captive dependency; `WorkbookSelectionStatsCache` and `SortDialogLevel` INPC are correct; `PeriodicTimer` usages are `using`-scoped.

---

## 8. Recommended Triage Order

1. **Command atomicity** (§3 High ×2) — wrap `CommandBus.Execute`/`CompositeWorkbookCommand.Apply` in try/catch+rollback. Highest data-integrity payoff, contained change.
2. **Incremental recalc spill staleness** (§2 High) — wire the spill-dependent pass into `Recalculate`.
3. **Sentry PII redaction** (§5 High) — privacy; small, isolated change in `SetBeforeSend`.
4. **Range-shrink on partial delete** (§2 High) — fixes a wrong-result on a very common edit.
5. **CSV import determinism + size guard** (§4 Medium cluster) — switch to invariant parsing (or explicit import-culture option) and add an input-size cap.
6. **Avalonia parity** (§6 High/Medium) — manifest, RIDs, version stamp, `async void` guards — before the macOS/Linux build is shipped.
7. **Thread-safe shared stores** (§6 High) and **dependency bumps** (Sentry/Velopack; FluentAssertions license).

Lower-severity items (the various bare-catch narrowings, duplication cleanup, doc fixes) are good follow-ups but not release-blocking.
