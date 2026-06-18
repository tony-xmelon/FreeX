# FreeX Code Review — 2026-06-18 (Iteration 2: merged Linux-parity surface)

## 0. Method And Coverage

Follow-up review after iteration 1's fixes were merged to `main` (`8fdf34a73`). This pass targets the ~4,810 lines of new code that merged in from `origin/main` between the iteration-1 base (`d68d140b1`) and `2ce0d88a4` — the Avalonia Linux-parity work (chart/picture/shape/pivot/table contextual ribbon tabs, proofing, window management, thesaurus), the App.Host status-bar refactor, and the chart deviation-overlay / form-control rendering. None of this was in the original 2026-06-18 review. Three independent finder passes over the diff, each verified against source.

## 1. Findings And Resolution

### Fixed this iteration (branch `codex/code-review-iter2-2026-06-18`)

- **[Critical] `async void` chart contextual-tab handlers crash the dispatcher on throw.** Seven handlers in `MainWindow.ChartTabs.cs` (`ShowChangeChartTypeDialog`, `ShowSelectChartDataDialog`, `ShowChartTitlesDialog`, `ShowChartShapeFillDialog`, `ShowChartShapeOutlineDialog`, `ShowChartPlotAreaFillDialog`, `ShowChartSeriesColorDialog`) were `async void` and awaited dialogs with no try/catch — the exact crash class fixed in iteration 1. **Fix:** converted to `async Task` and routed every fire-and-forget contextual-tab command (chart + picture/shape + help + remove-duplicates) through a new `RunGuarded(Func<Task>)` launcher that surfaces exceptions on the status bar.
- **[High] Equation dialog could never be closed (NRE).** `MainWindow.Proofing.cs` Insert/Cancel handlers called `((Window)layout.Parent!.Parent!).Close()`, but `layout` is the Window's `Content`, so `Parent.Parent` is null → `NullReferenceException`. **Fix:** capture the dialog via a closure and call `dialog?.Close()`.
- **[High] `HiddenWindows` static registry leaked closed windows.** `MainWindow.WindowManagement.cs` added `this` to a static list on Hide but never removed it; a window hidden then closed pinned its whole `WorkbookSession`/document graph for the session. **Fix:** added an `OnClosed` override that removes `this` from the registry.
- **[Medium] Proofing commit bypassed the open/save re-entrancy guard.** `CommitProofingText` mutated the model with no `_isOpening`/`_isSaving` check (unlike every other contextual handler). **Fix:** added the guard.
- **[Medium] Picture/shape async handlers swallowed exceptions** (`() => _ = …Async()`). **Fix:** routed through `RunGuarded` so failures surface instead of becoming unobserved task exceptions.
- **[Medium] `BackstageProgressOverlayPlanner.Plan` could throw `ArgumentException`** via `Math.Clamp` when a ProgressBar had `Min > Max`. **Fix:** raise the upper bound to the lower one so a degenerate range clamps to minimum.

**Verification:** `FreeX.slnx` Release build 0 warnings / 0 errors; `FreeX.DefaultTests.slnx` all green (~19,950 tests, incl. `FreeX.App.Avalonia.Tests`).

### Iteration 3 update (branch `codex/code-review-iter3-2026-06-18`)

- **[Medium] Chart contextual handlers acting on a stale chart reference — FIXED.** All seven `MainWindow.ChartTabs.cs` handlers now re-resolve the selected chart via `TryGetSelectedChart` after their dialog `await` (mirroring the shape handlers), so a command acts on the currently-selected chart, not the one captured before the dialog opened.
- **[Medium] Deviation-overlay range-label merge "collision" — RECLASSIFIED, not a bug.** The per-`PointIndex` merge is intentional and documented: the overlay draws exactly one floating label per category above the column cluster, so keying by `(SeriesIndex, PointIndex)` would render overlapping duplicates.
- **[Low] Deviation zero-test (`< double.Epsilon`) — RECLASSIFIED, not a bug.** For normal doubles this is equivalent to "exactly equal," matching the comment; any real deviation still draws a bar.

Verification: `FreeX.slnx` Release build 0/0; `FreeX.DefaultTests.slnx` all green.

### Deferred (genuine findings, larger or lower-value — next iterations)

- **[High] "Value From Cells" range data labels are dropped on XLSX save** — `XlsxChartDataLabelReader` reads `c15:datalabelsRange` into `ChartModel.RangeDataLabels`, but no writer emits it and the native (.fxl) DTO has no field for it, so the labels are lost on round-trip. **This is a feature, not a quick fix:** the reader discards the `c15:f` source-range formula, so faithful round-trip needs the model to capture `c15:f` per series and the writer to emit the full `datalabelsRange` (formula + cache) — and ideally Excel validation, which isn't available in this environment. Tracked for a dedicated change.
- **[Medium] Avalonia status-bar path has no view-model cache** — re-allocates/re-formats every refresh; the WPF host added `StatusBarViewModelCache`, the Avalonia path didn't (parity + allocation-churn gap).
- **[Low] `DrawingObjectEffect.Opacity` defaults to 0** (fully transparent — latent if a future caller/deserialization omits it); `DrawFormControlSunkenEdge` doesn't draw the highlight lines its comment promises.

## 2. Pre-existing Blocker (NOT introduced by this work)

The UI test lane (`FreeX.App.Host.Tests`) is **red on the current `main`** — ~131 failures across ribbon-structure, backstage-source-hygiene, dialog-focus, and adaptive-ribbon tests. Confirmed pre-existing by stashing this branch's changes (leaving exactly `origin/main 8fdf34a73`) and re-running a failing subset: it fails identically (20/22). These tests read/assert WPF `App.Host` source and behavior that this branch never touches; the breakage came in with the merged Linux-parity/ribbon/status-bar refactor (or requires an interactive desktop session). The default lane — the standard agent gate — is green. **Recommended next step:** a dedicated investigation of the WPF UI lane on `main` (test-vs-source drift from the refactor vs. environment), tracked separately from the Avalonia review stream.
