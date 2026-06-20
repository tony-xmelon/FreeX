# macOS Parity — Realignment onto on-main structure

The earlier macOS parity effort (branch `worktree-macos-parity`, ~30 verified batches) was built
off an older `main` and diverged structurally from the **parallel cross-platform effort that has
since landed on `main`**. Rather than force-merge two incompatible architectures, this branch
(`macos-parity-realign`, off current `origin/main`) **re-folds the reusable work onto the on-main
structure** so it merges cleanly.

## On-main structure (the target)
- `shared/Free.Shared.Ribbon` (net10.0) — neutral ribbon core (definition records, builder,
  `RibbonCommandRegistry` + `IRibbonCommand`/`IRibbonStatefulCommand`, icon geometry). ≈ the old
  branch's `FreeX.Ribbon`, enhanced.
- `shared/Free.Shared.Ribbon.Avalonia` (net10.0) — `AvaloniaRibbonRenderer` + `AvaloniaRibbonIcons`. ≈ the
  old branch's `RibbonAvaloniaControlFactory`.
- `shared/Free.Shared.AppServices` + `src/FreeX.App.Services` — portable app logic / planners.
- `src/FreeX.App.Avalonia` — the shell; ribbon is **default**, built via `AvaloniaRibbonHost` +
  `SampleRibbon.BuildDefinition()/BuildRegistry()` (only Bold/Italic/Underline wired; rest NoOp).

## What the old branch had that does NOT exist on main (port these)
- **`FreeX.App.Presentation`** (net10.0, Core-only, 988 tests) — the portable evaluation/layout/
  dialog-model layer: conditional-format eval, chart layout engine (+trendlines/bubble/radar/stock/
  combo), grid- & drawing-interaction planners, sparkline + shape geometry, page/print layout +
  page-content render model, pivot-UI models, slicer/timeline layout, dialog-backing models
  (CF schema, find/replace options, number-format metadata, data-validation, function-arg),
  quick-analysis, text-to-columns, consolidate, defined-names, protection. **Ported as-is (R1).**
- Avalonia **features** missing on main: charts render+insert, conditional-formatting render,
  pivot field pane + header dropdowns, sparklines/slicers/timelines render, Quick Analysis,
  Text-to-Columns, Consolidate, Name Manager, Print Preview, Page Setup, Protect Sheet,
  insert chart/table, broader ribbon command wiring.

## What to DROP (duplicates of on-main work)
- The old `FreeX.Ribbon` / `FreeX.Ribbon.Definitions` projects and `RibbonAvaloniaControlFactory`
  → use `Free.Shared.Ribbon` + `Free.Shared.Ribbon.Avalonia`.
- Duplicate dialogs already on main: Format Cells, Data Validation, Find/Replace/Go To, Goal Seek,
  Scenario Manager, Data Table, Forecast Sheet, Subtotal, Advanced Filter, Remove Duplicates,
  drawing-object editing.
- The old `IRibbonCommandHost`/`RibbonCommandBindings` wiring → wire commands through main's
  `RibbonCommandRegistry` + command factories (e.g. `WorkbookFormatRibbonCommands`).

## Plan
- **R1 ✅** Port `FreeX.App.Presentation` + tests onto this branch; registered in solutions + lane
  guard; 988 tests green against main's Core.* (no API drift).
- **R2+** Port the missing Avalonia features onto main's shell, consuming the Presentation models
  and wiring via main's ribbon registry, one verified batch at a time. Re-apply UI onto main's
  `MainWindow.cs` (skip duplicates). Each batch: build + default lane green, commit.
- Do **not** push to `main` (it churns rapidly with many concurrent efforts); land via a reviewed
  integration when ready.

The old branch `worktree-macos-parity` is preserved as the source of truth for the feature/UI code
to port.
