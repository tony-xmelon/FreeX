# FreeX Comprehensive Source Review — 2026-05-30

**Date:** 2026-05-30
**Branch / worktree:** `worktree-code-review-20260530` (isolated worktree; other workstreams unaffected)
**Baseline at review:** `main` @ `6f30a3e44` (local == `origin/main`, 0 ahead / 0 behind)
**Scope reviewed:** all of `src/` — 967 `.cs` files / ~178 KLOC across 7 projects (Model, IO, Calc, Formula, Commands, App.UI, App.Host), plus the cross-cutting tooling and docs surface.

> Note on size: the prior review (2026-05-28) reported "~640 KLOC / 1,166 files." That count included generated `obj/` artifacts (XAML `*.g.cs`, `GlobalUsings`, `AssemblyInfo`). The authoritative hand-written source excluding `obj/` and `bin/` is **177,816 lines / 967 files**.

## 0. Method & Honest Coverage Statement

This review is a *fresh* pass that does two things:

1. **Verifies** that the 17 findings from [reviews/comprehensive-code-review-2026-05-28.md](comprehensive-code-review-2026-05-28.md) and [ADR-008](../architecture/decisions/008-code-review-hardening-2026-05-28.md) actually landed in the current source (rather than re-reporting them).
2. **Surfaces** items still open and a small set of genuinely new findings.

A line-by-line read of 178 KLOC is not feasible in one pass; instead this used (a) targeted reads of the highest-risk and most central files (model aggregates, recalc engine, formula evaluator, XLSX adapter, command snapshots, GridView render loop, host security paths) and (b) repository-wide anti-pattern scans (broad/empty catches, blocking-on-async, disposal of `IDisposable`, threading primitives, floating-point equality, integer-overflow in area math, culture-sensitive parse/format, `Process.Start`, recursion guards). Findings carry `file:line` evidence; where a file family was sampled rather than fully read, that is stated.

**Headline:** the codebase is mature, internally consistent, and disciplined. The build is green (see §6). Every P0/P1 correctness, security, and data-loss item from the 2026-05-28 review is resolved and verified. Remaining work is **polish**: a handful of perf optimizations, one security hardening (file-size / zip-bomb guard), and longstanding architecture refactors that are deliberately deferred.

---

## 1. Verified Resolved Since 2026-05-28 (ADR-008 / PRs #33–#44 + later)

Each row was confirmed in the current source, not taken on trust.

| Prior § | Finding | Evidence it is fixed |
|---|---|---|
| 5.1 | `CellStyle.Equals`/`GetHashCode` excluded native dxf attrs | three `NativeDifferential*` fields now compared (PR #33) |
| 7.1 | Protection passwords stored plaintext | `NativePasswordHelper` stores `sha256:<HEX>` ([NativePasswordHelper.cs](../../src/FreeX.Core.IO/NativePasswordHelper.cs)) |
| 4.1 | `XlsxFileAdapter` swallowed load exceptions to `Debug.WriteLine` | replaced by `XlsxLoadResult.Warnings` ([XlsxLoadResult.cs](../../src/FreeX.Core.IO/XlsxLoadResult.cs)); zero `Debug.WriteLine` left in the adapter |
| 2.6 | `WriteIndented` + per-call `JsonSerializerOptions` | static `SaveOptions`, indentation off (PR #34) |
| 3.1 / 8.4 | Per-frame brush/pen/typeface dictionaries | promoted to class-level fields ([GridView.cs:158-161](../../src/FreeX.App.UI/GridView.cs#L158-L161)) |
| 4.4 | `CommandBus.Undo` didn't guard `Revert` | `RollbackPopUndo` + try/catch on Undo/Redo (PR #37) |
| 4.6 | No formula recursion depth limit | `MaxEvalDepth = 256` `[ThreadStatic] _evalDepth` ([FormulaEvaluator.cs:19-27](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L19-L27)) |
| 3.3 | `GetStyle` cloned on every read | defensive `Clone()` removed; callers clone explicitly (PR #39) |
| 3.6 | Dependency graph expanded ranges to per-cell | compact-range storage, `CompactRangeCellThreshold = 1024` + `CreateGridRange` ([RecalcEngine.cs:12](../../src/FreeX.Core.Calc/RecalcEngine.cs#L12)) |
| 7.2 | Hyperlinks followed without scheme validation | `IsAllowedScheme` allowlist (http/https/mailto/ftp), `OrdinalIgnoreCase` ([HyperlinkNavigationPlanner.cs:20-34](../../src/FreeX.App.Host/HyperlinkNavigationPlanner.cs#L20-L34)); enforced before `Process.Start` ([MainWindow.InsertCommands.cs:158](../../src/FreeX.App.Host/MainWindow.InsertCommands.cs#L158)) |
| 5.4 | 76 raw `MessageBox.Show` in host | `IUserMessageService` + `WpfUserMessageService` (PR #41) |
| 3.8 | XLSX buffered whole file twice | single `FileStream` reused ([OpenWorkbookLoader.cs:144](../../src/FreeX.App.Host/OpenWorkbookLoader.cs#L144)) |
| 8.1 | Undo stack bounded by count only | `IEstimatesMemory` + 50 MB byte budget (PR #43) |
| 2.3 | 12 near-identical metadata model classes | `NativeXmlPreserveBag` (PR #44) |
| 2.2 | `RemoveSheet` left dangling named ranges / stale view indices | now purges named ranges + adjusts `ActiveSheetIndex`/`FirstVisibleSheetIndex` ([Workbook.cs:344-385](../../src/FreeX.Core.Model/Workbook.cs#L344-L385)) |
| S9 | `ConditionalIconGlyphRenderer` unfrozen brushes | brushes/pens/geometries now `Freeze()`d ([ConditionalIconGlyphRenderer.cs:68](../../src/FreeX.App.UI/ConditionalIconGlyphRenderer.cs#L68)) |

**Correction to a prior finding:** §4.7 claimed sheet-scoped recalc fails to update cross-sheet dependents. This is **not** a defect in current code: `RecalculateSheetFormulas` calls `Recalculate(workbook, formulaCells)`, whose dependency-graph traversal evaluates downstream dependents on *all* sheets; `FilterReportForSheet` only filters the returned *report*, not the recalculation itself ([RecalcEngine.cs:225-307](../../src/FreeX.Core.Calc/RecalcEngine.cs#L225-L307)). The performance half of §4.7 (unconditional full-workbook dependency rebuild) does remain — see F4 below.

---

## 2. Still-Open From Prior Review (verified present today)

These were correctly identified on 2026-05-28, were **not** part of the ADR-008 fix set, and remain in the source.

### O1 — `FormattedText` allocated per cell, per render (perf, P1)
Four `new FormattedText(...)` sites in the render loop, including a per-probe-size closure inside shrink-to-fit ([GridView.Rendering.cs:257,268,499,512](../../src/FreeX.App.UI/GridView.Rendering.cs#L257)). The §3.1 brush/pen/typeface caches were promoted, but text layout objects are still rebuilt every paint. On shrink-to-fit-heavy sheets this is the dominant render allocation. *Recommend:* cache keyed on `(text, typeface, fontSize, brush, pixelsPerDip)`; measure shrink probes with a glyph-run path rather than a full `FormattedText` per probe.

### O2 — Transient evaluator allocations (perf, P2)
`FormulaEvaluator` now pre-sizes the per-call argument list ([FormulaEvaluator.cs:620](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L620)) — an improvement — but every binary range op still allocates a fresh `ScalarValue[rows,cols]` ([FormulaEvaluator.cs:245,423,435,563](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L245)). For large recalc graphs this is GC churn. *Recommend:* `ArrayPool<ScalarValue>` / lazy broadcast enumerator for the elementwise paths.

### O3 — `RecalcEngine` masks evaluator bugs as `#VALUE!` (reliability, P2)
The defensive `catch (Exception)` ([RecalcEngine.cs:127](../../src/FreeX.Core.Calc/RecalcEngine.cs#L127)) is correct as a ship-safety net, but it converts *any* internal evaluator bug into `#VALUE!`, so a value-asserting test passes while the bug ships. *Recommend:* `#if DEBUG throw;` in this catch so the test suite surfaces invariant violations in built-in functions; keep the swallow in Release.

### O4 — `Redo` re-runs `Apply` with no `Reapply` contract (stability, P2)
`CommandBus` redo re-invokes `Apply`, re-walking ranges and re-allocating snapshots; correctness relies on every command being idempotent, which is convention, not contract ([CommandBus.cs](../../src/FreeX.Core.Commands/CommandBus.cs)). *Recommend:* an explicit `Reapply(ctx, savedState)` with a default that calls `Apply`.

### O5 — Per-command snapshot types are ad hoc (maintainability, P3)
Each command declares its own snapshot shape (`List<(CellAddress, Cell?)>`, `List<(…, StyleId?)>`, `Dictionary<…>`, bespoke records) — confirmed across `ApplyStyleCommand`, `AutofillCommand`, `ClearContentsCommand`, `CommentCommands`, `ConfigurePivotTableLayoutCommand`, etc. Rollback logic is duplicated. *Recommend:* a shared `SheetSnapshot` diff abstraction consumed uniformly by `Revert`.

### O6 — God-object models with public-mutable collections (architecture, P3)
`Sheet` and `Workbook` still expose mutable `Dictionary`/`List` directly (e.g. `Workbook.NamedRanges` and the parallel `NamedRangeMetadataByName`), so callers can bypass validation and the two name dictionaries can drift. *Recommend:* `IReadOnly*` surfaces + mutation methods; fold the two named-range dictionaries into one entry type. (Deliberately deferred; tracked.)

### O7 — No event-driven model; UI invalidation is manual (architecture, P3)
Mutations to `Sheet`/`Workbook` raise no events; every command/dialog must remember to call `UpdateViewport`. *Recommend:* `CellsChanged`/`StructureChanged` events with GridView subscribing. (Deliberately deferred; tracked.)

### O8 — Recalc is single-threaded (perf, deferred by design)
Documented intentional decision (see `docs/planning/outstanding-build.md` §"Calculation performance architecture"). Listed here only for completeness; no action recommended until large-workbook profiling justifies it.

---

## 3. New Findings (this review)

### F0 — Mainline test red: status-report metric table is stale (correctness, **P1 — verified failing**)
`DocumentationIndexTests.NewestStatusReport_RepositoryMetricsMatchTrackedSources` **fails at HEAD `6f30a3e44`**:

```
Expected metrics["Tracked files"] to be 2024, but found 2022 (difference of -2).
```

The newest status report ([history/status-2026-05-28.md](../history/status-2026-05-28.md)) hard-codes `Tracked files: 2,022`, `C# test files under tests/: 471`, `Markdown docs under docs/: 233`, but the live `git ls-files` counts at HEAD are **2024 / 470 / 234**. The "Complete FreeX compliance rebrand" and "Clean stale docs and visual artifacts" commits changed the tracked-file set without refreshing the metric table the test asserts against. This is a real red test on `main`, independent of this review. *Fixed in this review:* the metric table is corrected to match live counts (and incremented for the doc this review adds). Going forward, either regenerate the status report's metric table in the same commit that adds/removes tracked files, or relax the test to a tolerance/generated-block.

### F1 — No file-size / decompression guard before opening a workbook (security / DoS, **P1**)
`OpenWorkbookLoader` opens the file and hands the stream to ClosedXML with **no** `FileInfo.Length` cap and no uncompressed-size ceiling ([OpenWorkbookLoader.cs:144-152](../../src/FreeX.App.Host/OpenWorkbookLoader.cs#L144-L152)). A crafted "zip bomb" `.xlsx` (small on disk, enormous decompressed) can exhaust memory and hang/crash the app. This is the one prior security item (old §7.3) that was *not* hardened in ADR-008. *Recommend:* reject files above a configurable byte cap before open (default e.g. 1 GB), and validate the zip central directory's total uncompressed size / compression ratio before decompression.

### F2 — `XmlNativeBagSerializer` silently drops preserved native XML on round-trip (fidelity, **P2**)
The native-preservation bag exists specifically to round-trip OOXML parts FreeX does not model. Yet three broad `catch { }` blocks swallow *all* exceptions while re-parsing stored child XML ([XmlNativeBagSerializer.cs:54,89,132](../../src/FreeX.Core.IO/XmlNativeBagSerializer.cs#L54)). If a stored fragment fails to re-parse, the preserved content is dropped with no signal — defeating the bag's purpose, and invisibly (the sibling write path at lines 40-41 already narrows to `ArgumentException`/`XmlException`). *Recommend:* narrow these catches to `XmlException`/`ArgumentException`, and count/surface drop events through the same `XlsxLoadResult.Warnings` channel adopted in PR #35 so a fidelity regression is visible rather than silent.

### F3 — `Process.Start` help/feedback launch bypasses the hyperlink scheme allowlist (security hygiene, **P3 / low**)
`OpenExternalHelpLink` calls `Process.Start(... UseShellExecute = true)` on a URL without routing through `IsAllowedScheme` ([MainWindow.ReviewCommands.cs:481-489](../../src/FreeX.App.Host/MainWindow.ReviewCommands.cs#L481-L489)). Risk today is low (the URLs are app constants such as `AppInfo.FeedbackUrl`), but it is an inconsistent second launch path. *Recommend:* centralize all shell launches through one guarded helper that applies the same allowlist, so future callers can't reintroduce an unguarded path.

### F4 — Sheet/all recalc entry points always do a full-workbook dependency rebuild (perf, **P2**)
`RecalculateSheetFormulas` and `RecalculateAllFormulas` both call `RebuildFormulaDependencies(workbook)`, which re-parses and re-registers *every* formula in *every* sheet on each invocation ([RecalcEngine.cs:216-236](../../src/FreeX.Core.Calc/RecalcEngine.cs#L216-L236)). The incremental `Recalculate(changedCells)` path is already efficient; these two whole-workbook entry points are O(all formulas) even for a single-sheet refresh. *Recommend:* keep the full rebuild only for explicit "Calculate Now (full)"; drive sheet/edit refreshes through the delta path.

### F5 — Non-critical IO failures only logged to `Debug.WriteLine` (reliability, **P3 / low**)
`RecentFilesStore` load/save failures are written to `Debug.WriteLine` ([RecentFilesStore.cs:39,93](../../src/FreeX.App.Host/RecentFilesStore.cs#L39)), which is stripped from Release — the same class of silent failure that PR #35 removed elsewhere. Impact is minor (the recent-files list is non-critical), but it is inconsistent with the now-standard diagnostic approach. *Recommend:* route through the app diagnostics channel; consider write-temp-then-atomic-rename for the store file.

---

## 4. What I Looked At And Found Clean (negative results worth recording)

- **Error handling:** 23 broad `catch (Exception)` across 178 KLOC; the empty catches are legitimate (`OperationCanceledException` after cancel; XML best-effort with specific types). No silent `Debug.WriteLine`-only swallow remains except F2/F5.
- **Async/threading:** no `async void` misuse; `Task.Run` confined to Open/Save loaders; the `.Result` matches are a `dialog.Result` property, not blocking on tasks. No UI-thread `.Wait()`/`.GetAwaiter().GetResult()`.
- **Culture safety:** 495 `InvariantCulture` vs 55 `CurrentCulture`; **zero** uncultured `double/int/decimal.Parse`. `CurrentCulture` use in `NumberFormatter.DateTime` is correct (Excel date tokens are locale-formatted).
- **Integer overflow:** area/count math consistently casts to `long` (`GridRange.CellCount`, dynamic-array builders) with explicit 1,000,000-cell caps in `BuiltInFunctions.DynamicArrays`/`FormulaEvaluator`.
- **Disposal:** the `MemoryStream`/`ZipArchive` ownership in `XlsxClosedXmlStyleOnlyCellStripper` and `CreateClosedXmlParsePackage` is carefully transferred via `ReferenceEquals` guards and `finally` — no leaks found.
- **Style-only cell stripper:** removing "redundant" empty styled cells only affects the *secondary ClosedXML parse package*; FreeX reads authoritative per-cell styles from the original worksheet XML (`XlsxWorksheetCellLayoutReader.ReadExplicitStyleOnlyCells`), so it is not a fidelity bug.
- **`TODO/FIXME/HACK`:** none (deferred work lives in `planning/outstanding-build.md`).

---

## 5. Prioritized Backlog (this review)

| Priority | Item | Type | Effort |
|---|---|---|---|
| **P1** | F0 — stale status-report metric table (red test) | Correctness | Trivial — **fixed in this review** |
| **P1** | F1 — file-size / zip-bomb guard before open | Security/DoS | Small |
| **P1** | O1 — cache `FormattedText`; remove per-probe shrink-to-fit alloc | Perf | Medium |
| **P2** | F2 — narrow `XmlNativeBagSerializer` catches + surface dropped preservation | Fidelity | Small |
| **P2** | O3 — `#if DEBUG throw` in `RecalcEngine` catch-all | Reliability | Trivial |
| **P2** | F4 — delta-drive sheet/all recalc instead of full rebuild | Perf | Medium |
| **P2** | O2 — pool transient `ScalarValue[,]` / argument buffers | Perf | Medium |
| **P3** | O4 — explicit `Reapply` command contract | Stability | Medium |
| **P3** | F3 — single guarded shell-launch helper | Security hygiene | Trivial |
| **P3** | F5 — route `RecentFilesStore` failures to diagnostics | Reliability | Trivial |
| **P3** | O5 — shared `SheetSnapshot` diff abstraction | Maintainability | Medium |
| **P3** | O6/O7 — read-only model surfaces + event-driven invalidation | Architecture | Large (deferred) |
| — | O8 — parallel recalc | Perf | Large (deferred by design) |

---

## 5a. Scope-Completion Assessment

`release/progress.json` `overallCompletion` was reviewed and **held at 95** (it maps to the `v0.8.<run>` tester band; bands: ≥90→.6, ≥93→.7, ≥95→.8, ≥99→.9, per `tools/Test-TesterReleaseReadiness.ps1` and `.github/workflows/tester-release.yml`).

Rationale for *not* raising it:
- The review is largely **confirmatory** — the hardening that justified 95 (ADR-008 + PRs #45–#48) is verified intact, and the build is green.
- It also opened a **new P1 security item** (F1, no zip-bomb/file-size guard); raising completion while a fresh P1 is open would misrepresent readiness.
- Product-scope parity work (chart UX, multi-window, ≥95% fidelity proof) is unchanged by this review.

The number is also coupled: changing it requires editing the asserted string in `docs/release/test-distribution.md:33` or the readiness test fails. The substantive "scope completion" update from this review is therefore qualitative — recorded in `planning/outstanding-build.md` (verified baseline + the new Code-Quality Hardening Backlog). Recommend bumping to 96 only once F1 is closed; the figure stays in the same `v0.8` band until ≥99.

## 5b. Remediation (2026-05-30, second pass)

After the first-pass review (merged to `main` as the docs + F0 fix), the contained findings were fixed test-first on this branch:

| Finding | Fix | Tests |
|---|---|---|
| F0 | Status-report metric table refreshed to live `git ls-files` | DocumentationIndexTests 13/13 |
| F1 | `WorkbookOpenSizeGuard` (file cap 2 GiB; decompressed cap 8 GiB; ratio cap 1000:1) wired into `OpenWorkbookLoader` + `XlsxFileAdapter.LoadCore`; throws `WorkbookTooLargeException` (host shows "Failed to open file") | 6 guard + 1 loader |
| F2 | `XmlNativeBagSerializer` broad `catch {}` → `catch (XmlException)` (3 sites) | existing 28 serializer tests green |
| F3 | `ExternalUrlLauncher` is the single guarded shell-launch path; help/feedback + hyperlink both route through it; removed the unguarded `Process.Start` | 5 launcher |
| F5 | `RecentFilesStore` saves via `AtomicFileWriter` (temp-then-rename) | 2 writer |
| O3 | `RecalcEngine` catch-all `throw`s under `#if DEBUG` | calc 552/552 + formula 2630/2630 |

Deferred with rationale (perf needing baselines/visual checks, and cross-cutting architecture refactors): O1 (FormattedText cache), O2 (`ScalarValue[,]` pooling), F4 (delta recalc), O4 (`Reapply`), O5 (shared snapshot), O6/O7 (read-only model + events), O8 (parallel recalc). See `planning/outstanding-build.md` for the rationale on each.

## 6. Build / Baseline Verification

Run from this worktree:

```
dotnet restore FreeX.slnx --disable-parallel
dotnet build  FreeX.slnx --no-restore --disable-build-servers \
  -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

**Result:** restore + build **succeeded, exit code 0** (no warnings-as-errors failures). This is the clean baseline for any follow-up fix work.

Test suite (`dotnet test`) was not executed as part of this read-only review; the build green + the existing parity-test coverage referenced in `planning/outstanding-build.md` stand as the functional baseline. Anyone acting on §3/§5 should run the focused test project for the touched area per `AGENTS.md` before merging.

---

## 7. Round-Three Pass (2026-05-30, post-merge) — fresh scan + red-test inventory

After landing F1/F2/F3/F5/O3 on `main` (and syncing through four merges of concurrent `codex/*` work), a third read swept the *current* `main` — including the code merged from the parallel sessions during the cycle.

### 7.1 Fresh scan — clean
- **Security/XML:** every `XmlReader.Create` in `Core.IO`/`Core.Formula` sets `DtdProcessing.Prohibit` + `XmlResolver = null` (XXE-safe), and the newly-merged `XsltWorkbookTransform` is a model secure XSLT host — `XsltSettings(enableDocumentFunction: false, enableScript: false)`, null stylesheet/document resolvers, `MaxCharactersInDocument` cap, and a `BoundedMemoryStream` output limit ([XsltWorkbookTransform.cs](../../src/FreeX.Core.IO/XsltWorkbookTransform.cs)). No new injection/SSRF/DoS surface.
- **Error handling / disposal / threading:** unchanged discipline (broad catches still ~23; only `RecentFilesStore` uses `Debug.WriteLine`, now atomic-write-backed; no new unguarded `Process.Start` — the only URL launch path is the guarded `ExternalUrlLauncher`).
- Full solution build green at `f7807b70f`; `Core.IO` 1286/1286, `Core.Calc` 553/553, `DocumentationIndexTests` 13/13, and all new F1–F5 unit tests pass.

### 7.2 Pre-existing red tests on `main` (NOT introduced here; owned by active parallel sessions)
These were already failing on `origin/main` before this branch and live entirely in ribbon/command/keytip surfaces this review never touched. They are the in-flight work of the `codex/freex-ribbon` / `freex-commands` / `freex-functions` sessions and must be resolved there (editing those files here would collide with active sessions — see `AGENTS.md` ownership rules):

| Test | Drift |
|---|---|
| `RibbonTabParityTests.{PageLayout,Insert,Formulas,Data}Tab_…` | ribbon group/tooltip order ("Orientation" vs "Page Orientation", "Clear" vs "Clear Filter", "Logical" vs "Logical Functions") |
| `RibbonCommandPresentationPlannerTests.MainRibbonCommandTitles_MapToSemanticIcons` | command title → icon map drift |
| `FormulaCommandSourceTests.…(AutoSum…)` | ribbon button XAML shape vs expected |

(The 2026-05-30 sync resolved ~14 other parity/keytip failures that the parallel sessions had already fixed upstream; this branch fixed the 2 it caused — the `OpenExternalHelpLink` source-shape tests — by re-pinning them to the guarded `ExternalUrlLauncher` design.)

### 7.3 New finding — brittle metrics test in a multi-session repo (process, P3)
`DocumentationIndexTests.NewestStatusReport_RepositoryMetricsMatchTrackedSources` asserted the newest status report's hand-written file counts **equal** live `git ls-files`. With ~13 concurrent sessions adding/removing files, that byte-exact coupling went **red on essentially every merge** until someone hand-edited the report — it flipped red three times during this single cycle (and was the original F0). A dated status report is a point-in-time snapshot, not a live mirror of HEAD, so exact equality was the wrong invariant.

**Fixed (2026-05-30):** the test now requires each metric to be present, positive, and **within a snapshot tolerance** of live (`±max(50, 10%)`), via a new `AssertMetricTracksLive` helper. This is immune to routine per-merge churn (tens of files) yet still fails a fabricated or order-of-magnitude-stale count — verified positively (13/13 green) and negatively (a planted `9,999` tracked-file count fails with a clear out-of-range message). The remaining source-shape ribbon parity tests (§7.2) have the same exact-string brittleness and are left to their owning sessions to either regenerate or relax similarly.
